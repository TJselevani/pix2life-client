import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';

class GalleryDialog {
  static void showGalleryImagesDialog({
    required BuildContext context,
    required List<Photo> images,
    required String galleryName,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Blur effect for the background
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Centered container for the gallery dialog
              Center(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gallery title
                      Text(
                        galleryName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Horizontal list of images
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
                                  errorBuilder: (context, error, stackTrace) =>
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
  }
}
