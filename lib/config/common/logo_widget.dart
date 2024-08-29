import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/all_logos.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(AppPalette.transparent,
            BlendMode.color), // Change the color to your desired color
        child: Image.asset(
          Logo.pix2lifeLogo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
