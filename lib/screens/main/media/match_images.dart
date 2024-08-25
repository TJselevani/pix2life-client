import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:pix2life/config/common/text_animations.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:pix2life/screens/navigation/main_navigation_page.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageMatchScreen extends StatefulWidget {
  static Route(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  const ImageMatchScreen({super.key});

  @override
  State<ImageMatchScreen> createState() => _UploadImageMatchPageState();
}

class _UploadImageMatchPageState extends State<ImageMatchScreen> {
  final MediaService mediaService = MediaService();
  final ImagePicker _picker = ImagePicker();
  final log = logger(ImageMatchScreen);
  List<CameraDescription>? cameras;
  bool _isLoading = false;
  bool _isSet = false;
  bool _isReady = false;
  File? _imageFile;
  String? _matchedImage;
  String? _galleryName;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      setState(() {});
    } catch (e) {
      log.e('Failed to initialize cameras: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isReady = true; // Mark as ready to match
      });
    } else {
      setState(() {
        _isReady = false; // Reset if no file is picked
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isReady = true; // Mark as ready to match
      });
    } else {
      setState(() {
        _isReady = false; // Reset if no file is picked
      });
    }
  }

  Future<void> _uploadMatchImage() async {
    if (!mounted) return;
    setState(() {
      _matchedImage = null;
      _isLoading = true;
      _isSet = false;
    });

    File image = _imageFile!;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
    });

    try {
      final response = await mediaService.matchImage(formData);
      setState(() {
        _isSet = true;
        _matchedImage = response.image['url'];
        _galleryName = response.image['galleryName'];
      });

      if (!mounted) return;

      SuccessSnackBar.show(context: context, message: response.message);
      log.i('Successfully Matched Image: ${image.path.split('/').last}');
    } catch (e) {
      if (!mounted) return;
      ErrorSnackBar.show(context: context, message: 'Match Failed');
      log.e('Image Matching Failed ${image.path.split('/').last}: $e');
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showGalleryImages(String galleryName) async {
    try {
      final response = await mediaService.fetchImagesByGallery(galleryName);
      List images = response.images;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          galleryName,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(16)),
                        SizedBox(
                          height: ScreenUtil().setHeight(300),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              final image = images[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(8)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(12)),
                                  child: Image.network(
                                    image.url,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.image_not_supported),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      log.e('Failed to fetch images: $e');
    }
  }

  Widget _buildImageContainer(String label, File? imageFile, bool isLoading,
      {bool isMatchedImage = false}) {
    return Container(
      width: ScreenUtil().setWidth(150),
      height: ScreenUtil().setHeight(150),
      decoration: BoxDecoration(
        color: AppPalette.redColor1,
        shape: BoxShape.rectangle,
      ),
      child: imageFile == null
          ? Center(
              child: isLoading
                  ? LoadingAnimationWidget.beat(
                      color: AppPalette.whiteColor,
                      size: ScreenUtil().setWidth(50),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
            )
          : isMatchedImage
              ? GestureDetector(
                  onTap: () => _showGalleryImages(_galleryName!),
                  child: CachedNetworkImage(
                    imageUrl: _matchedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Container(
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: ScreenUtil().setWidth(40),
              color: AppPalette.redColor1,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(37)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Text(
                      'Image Matching',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: ScreenUtil().setSp(24),
                        color: AppPalette.redColor1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    if (_isSet)
                      DisappearingText(
                        text: 'Tap on the Matched Image',
                        isVisible: _isSet,
                      ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildImageContainer(
                          'Your Image',
                          _imageFile,
                          false,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(20)),
                        _buildImageContainer(
                          'Matched Image',
                          null,
                          _isLoading,
                          isMatchedImage: true,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                            Icons.camera, 'Take Photo', _takePhoto),
                        _buildActionButton(Icons.browse_gallery,
                            'Search Gallery', _pickImageFromGallery),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    SizedBox(
                      width: ScreenUtil().setWidth(319),
                      child: RichText(
                        text: TextSpan(
                          text:
                              'Take a photo using your camera or pick an image from the gallery to match the image using our service.',
                          style: TextStyle(
                            color: AppPalette.greyColor0,
                            fontFamily: 'Poppins',
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          if (_isReady)
            _isLoading
                ? LoadingAnimationWidget.bouncingBall(
                    color: AppPalette.redColor1,
                    size: ScreenUtil().setWidth(30),
                  )
                : RoundedButton(
                    name: "Match Image",
                    onPressed: _uploadMatchImage,
                  ),
          SizedBox(height: ScreenUtil().setHeight(20)),
        ],
      ),
    );
  }
}
