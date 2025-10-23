import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/utils/date-format/format_timestamp.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_provider.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/presentation/views/update_image/update_image.dart';
import 'package:provider/provider.dart';

class ImageDialog extends StatelessWidget {
  final Photo image;
  final double targetValue;
  final AnimationController controller;

  const ImageDialog({
    super.key,
    required this.image,
    required this.targetValue,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    late bool isDarkMode;

    final themeProvider = Provider.of<MyThemeProvider>(context);
    final imageProvider = Provider.of<MyImageProvider>(context, listen: false);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent, // Semi-transparent background
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.8, end: targetValue),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppPalette.darkBackground
                            : AppPalette.lightBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Image should extend to the top, left, and right edges
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Hero(
                              tag: image.url,
                              child: CachedNetworkImage(
                                imageUrl: image.url,
                                height: 250.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: LoadingAnimationWidget.twoRotatingArc(
                                    color: AppPalette.red,
                                    size: 30.sp,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, size: 24.sp),
                              ),
                            ),
                          ),
                          // Bottom text fields for image details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'File Name: ${image.filename}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Created At: ${Utility.formatTimestamp('${image.createdAt}')}  (${Utility.getRelativeTime('${image.createdAt}')}  Ago) ",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Gallery: ${image.galleryName}',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Description: ${image.description}',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                          // Close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildButton(
                                context,
                                'Update',
                                () {
                                  // Close the current dialog
                                  Navigator.of(context).pop();

                                  // Open a new dialog with UpdateImageScreen
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: UpdateImageScreen(image: image),
                                    ),
                                  );
                                },
                              ),
                              _buildButton(
                                context,
                                'Delete',
                                () {
                                  imageProvider.deleteImage(image.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Padding _buildButton(
      BuildContext context, String label, VoidCallback onPress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: onPress,
        style: TextButton.styleFrom(
          backgroundColor: AppPalette.red,
          foregroundColor: AppPalette.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
