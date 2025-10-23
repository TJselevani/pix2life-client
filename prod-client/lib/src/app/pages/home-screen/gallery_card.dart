import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class GalleryCard extends StatelessWidget {
  final String title;
  final String description;
  final Color? color;
  final String? backgroundImage;
  final List<String>? imagePaths;
  final bool? isAsset;
  final bool? isAutoSlide;
  final PageController? controller;

  const GalleryCard({
    super.key,
    required this.title,
    this.color = AppPalette.transparent,
    this.backgroundImage,
    required this.description,
    this.imagePaths,
    this.isAsset = false,
    this.isAutoSlide = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250.w,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: color,
        ),
        child: imagePaths != null
            ? Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: imagePaths!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            image: DecorationImage(
                              image: isAsset == true
                                  ? AssetImage(imagePaths![index])
                                  : CachedNetworkImageProvider(
                                      imagePaths![index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildText(
                            title,
                            18,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.fontWhite,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            description,
                            style: TextStyle(
                                color: AppPalette.fontWhite, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.primaryGrey.withAlpha(230),
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(backgroundImage!.isNotEmpty
                            ? backgroundImage!
                            : AppImage.randomImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildText(
                            title,
                            18,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.fontWhite,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            description,
                            style: TextStyle(
                                color: AppPalette.fontWhite, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget _buildText(String text, double fontSize,
      {FontWeight fontWeight = FontWeight.normal,
      Color color = AppPalette.fontWhite}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
      maxLines: 1,
      style: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight),
    );
  }
}
