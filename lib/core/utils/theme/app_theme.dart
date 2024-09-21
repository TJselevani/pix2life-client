import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class AppTheme {
  static _borderLayout(
          [Color color = AppPalette.transparent,
          BorderStyle style = BorderStyle.none]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
          style: style,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppPalette.redColor1,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppPalette.appLightThemeBackgroundColor,
    appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.appLightThemeBackgroundColor),
    primaryColor: AppPalette.redColor1,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      hintStyle: TextStyle(
          color: AppPalette.greyColor0,
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400),
      filled: true,
      border: InputBorder.none,
      fillColor: AppPalette.inputBackgroundColor1,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.greyColor3, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorColor, BorderStyle.solid),
      focusedErrorBorder:
          _borderLayout(AppPalette.blueColor5, BorderStyle.solid),
    ),
  );

  static final DarkThemeMode = ThemeData.dark().copyWith(
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppPalette.redColor1,
    ),
    // colorScheme: ColorScheme(
    //   primary: AppPalette.redColor1,
    // ),
    scaffoldBackgroundColor: AppPalette.appDarkThemeBackgroundColor1,
    appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.appDarkThemeBackgroundColor1),
    primaryColor: AppPalette.redColor1,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      hintStyle: TextStyle(
          color: AppPalette.greyColor0,
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400),
      filled: true,
      border: InputBorder.none,
      fillColor: AppPalette.inputBackgroundColor1,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.greyColor3, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorColor, BorderStyle.solid),
      focusedErrorBorder:
          _borderLayout(AppPalette.blueColor5, BorderStyle.solid),
    ),
  );
}
