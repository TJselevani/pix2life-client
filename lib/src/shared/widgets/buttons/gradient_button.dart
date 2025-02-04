
import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class AuthGradientButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const AuthGradientButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.primaryBlue, AppPalette.primaryBlue],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: AppPalette.primaryWhite,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
