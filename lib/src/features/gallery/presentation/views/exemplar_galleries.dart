import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

// Temporary storage for existing galleries (you would usually fetch this from a backend)
final List<Map<String, String>> exemplarGalleries = [
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

Column showcaseGalleries() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Exemplar Galleries',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: AppPalette.red,
        ),
      ),
      SizedBox(height: 16.h),
      GridView.builder(
        shrinkWrap: true, // Ensure the GridView doesn't take up infinite height
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1 / 1,
        ),
        itemCount: exemplarGalleries.length,
        itemBuilder: (context, index) {
          final gallery = exemplarGalleries[index];
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
  );
}
