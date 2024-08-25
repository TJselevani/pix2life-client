import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  TextEditingController _galleryNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final MediaService mediaService = MediaService();
  final ImagePicker _picker = ImagePicker();
  final log = logger(GalleryScreen);
  bool _isLoading = false;
  bool _isSet = false;
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _isSet = true;
        _image = selectedImage;
      });
    }
  }

  Future<void> _createGallery() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    XFile image = _image!;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(image.path, filename: image.name),
      "galleryName": _galleryNameController.text.trim(),
      "description": _descriptionController.text.trim(),
    });

    try {
      final response = await mediaService.createGallery(formData);

      if (!mounted) return;

      setState(() {
        _galleryNameController.clear();
        _descriptionController.clear();
        SuccessSnackBar.show(context: context, message: response['message']);
        log.i('Successfully uploaded Avatar Image: ${image.name}');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        ErrorSnackBar.show(context: context, message: '$e');
        log.e('Upload failed for Avatar ${image.name}: $e');
      });
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isSet = false;
      _image = null;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _galleryNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Temporary storage for existing galleries (you would usually fetch this from a backend)
  final List<Map<String, String>> galleries = [
    {
      'name': 'Nature Gallery',
      'description': 'A collection of nature photos',
      'image': 'assets/images/A.jpg', // Replace with actual asset paths
    },
    {
      'name': 'Cityscape',
      'description': 'Urban and city landscape images',
      'image': 'assets/images/R.jpeg',
    },
    // Add more gallery data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Gallery',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppPalette.redColor1,
              ),
            ),
            SizedBox(height: 16.h),
            Card(
              color: AppPalette.whiteColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    if (_isSet)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        height: 278.h,
                        width: 283.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.w),
                          color: AppPalette.whiteColor,
                        ),
                        child: CircleAvatar(
                            backgroundImage: FileImage(File(_image!.path))),
                      ),
                    TextField(
                      controller: _galleryNameController,
                      decoration: InputDecoration(
                        labelText: 'Gallery Name',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Gallery Description',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.image, size: 24),
                          label: Text(
                            'Select Image',
                            style: TextStyle(
                              color: AppPalette.redColor1,
                              fontFamily: 'Poppins',
                              // fontSize: 15.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            iconColor: AppPalette.redColor1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppPalette.redColor1,
                                  strokeWidth: 2.w,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (_isSet) {
                                    _createGallery();
                                  } else {
                                    ErrorSnackBar.show(
                                        context: context,
                                        message: 'Image required');
                                  }
                                },
                                child: Text(
                                  'Create Gallery',
                                  style: TextStyle(
                                      color: AppPalette.redColor1,
                                      fontFamily: 'Poppins',
                                      fontSize: 15.sp),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Exemplar Galleries',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppPalette.redColor1,
              ),
            ),
            SizedBox(height: 16.h),
            GridView.builder(
              shrinkWrap:
                  true, // Ensure the GridView doesn't take up infinite height
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1 / 1,
              ),
              itemCount: galleries.length,
              itemBuilder: (context, index) {
                final gallery = galleries[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  elevation: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            gallery['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8.h,
                          left: 8.w,
                          right: 8.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gallery['name']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                gallery['description']!,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
