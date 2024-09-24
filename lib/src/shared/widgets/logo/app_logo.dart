import 'package:flutter/material.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class Pix2lifeLogo extends StatelessWidget {
  const Pix2lifeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(AppPalette.transparent,
            BlendMode.color), // Change the color to your desired color
        child: Image.asset(
          AppLogo.pix2lifeLogo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
