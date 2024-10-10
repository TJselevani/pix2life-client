import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class SlideInText extends StatelessWidget {
  final String? text;
  final bool isWidget;
  final Widget? widget;
  const SlideInText({
    super.key,
    this.text,
    this.isWidget = false,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    if (isWidget) {
      return Container(
        child: widget,
      );
    } else {
      return Text(
        text!,
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: AppPalette.primaryBlack),
      )
          .animate()
          .slideX(begin: -1.0, end: 0.0, duration: const Duration(seconds: 2));
    }
  }
}
