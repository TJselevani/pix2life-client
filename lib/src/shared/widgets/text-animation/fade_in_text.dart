import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FadeInText extends StatelessWidget {
  final String text;
  const FadeInText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
    ).animate().fadeIn(duration: const Duration(seconds: 2));
  }
}
