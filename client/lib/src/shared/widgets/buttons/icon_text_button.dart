import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class IconTextButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;

  const IconTextButton(
      {super.key, required this.name, this.onPressed, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppPalette.red,
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // text color
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(prefixIcon), // Your icon here
          const SizedBox(width: 20), // Space between icon and text
          Text(
            name, // Your text here
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
