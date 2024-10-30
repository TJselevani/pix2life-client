import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/date-format/format_timestamp.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_provider.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/presentation/views/update_video/update_video.dart';
import 'package:provider/provider.dart';

class VideoDialog extends StatelessWidget {
  final Video video;
  final double targetValue;
  final AnimationController controller;

  const VideoDialog({
    super.key,
    required this.video,
    required this.targetValue,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    late bool isDarkMode;

    final themeProvider = Provider.of<MyThemeProvider>(context);
    final videoProvider = Provider.of<MyVideoProvider>(context, listen: false);
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Icon(
                                  Icons.video_collection_rounded,
                                  size: 68,
                                  color: AppPalette.red,
                                )),
                          ),
                          // Bottom text fields for image details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'File Name: ${video.filename}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Created At: ${Utility.formatTimestamp('${video.createdAt}')}  (${Utility.getRelativeTime('${video.createdAt}')}  Ago) ",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Gallery: ${video.galleryName}',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Description: ${video.description}',
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
                                      child: UpdateVideoScreen(video: video),
                                    ),
                                  );
                                },
                              ),
                              _buildButton(
                                context,
                                'Delete',
                                () {
                                  videoProvider.deleteVideo(video.id);
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
