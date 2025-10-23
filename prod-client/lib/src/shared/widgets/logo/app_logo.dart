import 'package:flutter/material.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:provider/provider.dart';

class Pix2lifeLogo extends StatelessWidget {
  const Pix2lifeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppPalette.red : AppPalette.transparent,
          isDarkMode ? BlendMode.srcATop : BlendMode.color,
        ),
        child: Image.asset(
          AppLogo.pix2lifeLogo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
