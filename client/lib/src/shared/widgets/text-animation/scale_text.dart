import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class ScaleText extends StatelessWidget {
  final String text;
  const ScaleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.primaryBlack),
    ).animate().scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 2),
        duration: const Duration(seconds: 2));
  }
}
