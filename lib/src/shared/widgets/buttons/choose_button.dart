
import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class ChooseButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const ChooseButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.primaryBlack, AppPalette.primaryBlack],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppPalette.primaryWhite,
          width: 1.0,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 45),
          padding: EdgeInsets.zero, // Remove padding to align text left
          alignment: Alignment.centerLeft, // Align text to the left
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Add padding for text
          alignment: Alignment
              .centerLeft, // Align text to the left within the container
          child: Text(
            name,
            textAlign: TextAlign.left, // Align text to the left
            style: const TextStyle(
              color: AppPalette.primaryGrey,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}