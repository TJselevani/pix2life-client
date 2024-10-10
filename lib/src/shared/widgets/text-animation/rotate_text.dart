import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class RotateText extends StatelessWidget {
  const RotateText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Rotate',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: AppPalette.primaryBlack),
    )
        .animate()
        .rotate(begin: -1.0, end: 0.0, duration: const Duration(seconds: 2));
  }
}
