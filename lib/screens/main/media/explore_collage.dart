import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/services/media.services.dart';
import 'package:pix2life/models/entities/gallery.model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollageScreen extends StatefulWidget {
  const CollageScreen({super.key});

  @override
  State<CollageScreen> createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen> {
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
  ];

  MediaService mediaService = MediaService();
  final log = logger(CollageScreen);
  List<Gallery> fetchedGalleries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGalleries();
  }

  Future<void> _fetchGalleries() async {
    if (!mounted) return;
    try {
      final response = await mediaService.fetchGalleries();
      setState(() {
        fetchedGalleries = response.galleries;
        isLoading = false;
      });
    } catch (e) {
      // Handle any errors here
      if (mounted)
        setState(() {
          isLoading = false;
        });
      log.e('Failed to fetch galleries: $e');
    }
    if (!mounted) return;
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
                // Blurred background
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent, // Remove the black overlay
                    ),
                  ),
                ),
                // Gallery images display
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          galleryName,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 300.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              final image = images[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.w),
                                  child: Image.network(
                                    image.url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.image_not_supported),
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
      print('Failed to fetch images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Existing Galleries',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppPalette.redColor1,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: galleries.length + fetchedGalleries.length,
                      itemBuilder: (context, index) {
                        if (index < galleries.length) {
                          // Display existing galleries
                          final gallery = galleries[index];
                          return GestureDetector(
                            onTap: () => _showGalleryImages(gallery['name']!),
                            child: _buildGalleryCard(
                              name: gallery['name']!,
                              description: gallery['description']!,
                              imagePath: gallery['image']!,
                            ),
                          );
                        } else {
                          // Display fetched galleries from the database
                          final fetchedGallery =
                              fetchedGalleries[index - galleries.length];
                          return GestureDetector(
                            onTap: () =>
                                _showGalleryImages(fetchedGallery.name),
                            child: _buildGalleryCard(
                              name: fetchedGallery.name,
                              description: fetchedGallery.description,
                              imagePath: fetchedGallery.iconUrl.isNotEmpty
                                  ? fetchedGallery.iconUrl
                                  : 'assets/images/A.jpg', // Replace with actual placeholder image path
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryCard({
    required String name,
    required String description,
    required String imagePath,
  }) {
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
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  imagePath, // Local asset as fallback
                  fit: BoxFit.cover,
                ),
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
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
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
  }
}
