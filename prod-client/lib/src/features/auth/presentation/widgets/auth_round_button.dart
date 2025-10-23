import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;
  final bool useColor;

  const RoundedButton(
      {super.key, required this.name, this.onPressed, this.useColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: useColor
              ? [AppPalette.primaryBlack, AppPalette.primaryBlack]
              : [AppPalette.red, AppPalette.red],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppPalette.primaryWhite,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
