import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class NormalFlatButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const NormalFlatButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.primaryWhite, AppPalette.primaryWhite],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(5),
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
          style: const TextStyle(
            color: AppPalette.primaryGrey,
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
