import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:pix2life/functions/services/util.services.dart';
import 'package:pix2life/screens/main/update/edit_media.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  late Future<List<Map<String, dynamic>>> _images;
  final MediaService mediaService = MediaService();
  final log = logger(ImageGalleryPage);

  String _searchQuery = "";
  List<Map<String, dynamic>> _allImages = [];
  List<Map<String, dynamic>> _filteredImages = [];
  bool _isSearchVisible = false;
  String? _selectedImageName = 'Image Gallery';
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    _images = mediaService.fetchImages();
    _images.then((images) {
      setState(() {
        _allImages = images;
        _filteredImages = images;
        if (images.isNotEmpty) {
          final randomImage = images[Random().nextInt(images.length)];
          _selectedImageName = randomImage['filename'];
          _selectedImageUrl = randomImage['url'];
        }
      });
    });
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  void _refreshImages() {
    _loadImages();
  }

  void _filterImages(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredImages = _allImages;
      } else {
        _filteredImages = _allImages
            .where((image) =>
                image['filename'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showImageInfo(Map<String, dynamic> image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(image['filename']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('File Name: ${image['filename'] ?? 'Unknown'}'),
              Text('Description: ${image['description'] ?? 'No description'}'),
              Text('Gallery: ${image['galleryName'] ?? 'Media Gallery'}'),
              Text('Created: ${Utility.formatTimestamp(image['createdAt'])}'),
              Text('(${Utility.getRelativeTime(image['createdAt'])}) Ago'),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMediaScreen(
                          data: image,
                          type: 'image',
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppPalette.redColor,
                    foregroundColor: AppPalette.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Update'),
                ),
                SizedBox(width: 70.w),
                TextButton(
                  onPressed: () async {
                    try {
                      final imageId = image['id'];
                      final response = await mediaService.deleteImage(imageId);
                      Navigator.of(context).pop(); // Close the dialog
                      SuccessSnackBar.show(
                          context: context,
                          message: response.message); // Display the snackbar
                      _refreshImages(); // Refresh the images list
                    } catch (e) {
                      Navigator.of(context)
                          .pop(); // Close the dialog in case of error as well
                      ErrorSnackBar.show(
                          context: context,
                          message: 'Failed to delete image: $e');
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppPalette.redColor1,
                    foregroundColor: AppPalette.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      appBar: AppBar(
        title: GestureDetector(
          onTap: _toggleSearchVisibility,
          child: Text(
            _selectedImageName ?? 'Image Gallery',
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppPalette.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.refresh, size: 24.sp),
          onPressed: _refreshImages,
        ),
        bottom: _isSearchVisible
            ? PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    onChanged: _filterImages,
                    decoration: InputDecoration(
                      hintText: 'Search by name',
                      prefixIcon: Icon(Icons.search, size: 24.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _images,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.waveDots(
                color: AppPalette.redColor1,
                size: 50.sp,
              ),
            );
          } else if (snapshot.hasError) {
            log.e('snapshot error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No images found'));
          } else {
            // Categorize images by gallery name
            final galleryMap = <String, List<Map<String, dynamic>>>{};
            for (var image in snapshot.data!) {
              final galleryName = image['galleryName'] as String;
              if (!galleryMap.containsKey(galleryName)) {
                galleryMap[galleryName] = [];
              }
              galleryMap[galleryName]!.add(image);
            }

            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2.w, 2.h),
                        ),
                      ],
                    ),
                    child: _selectedImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: _selectedImageUrl!,
                            placeholder: (context, url) => Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                color: AppPalette.redColor1,
                                size: 50.sp,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, size: 24.sp),
                            fit: BoxFit.cover,
                          )
                        : Center(child: Text('No image selected')),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: galleryMap.entries.map((entry) {
                      final galleryName = entry.key;
                      final images = entry.value;

                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, bottom: 10.h),
                              child: Text(
                                galleryName,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 150.h, // Adjust the height as needed
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  final image = images[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImageName = image['filename'];
                                        _selectedImageUrl = image['url'];
                                      });
                                    },
                                    onLongPress: () {
                                      _showImageInfo(image);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(2.w, 2.h),
                                          ),
                                        ],
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: image['url'],
                                        placeholder: (context, url) => Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                            color: AppPalette.redColor1,
                                            size: 30.sp,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error, size: 24.sp),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
