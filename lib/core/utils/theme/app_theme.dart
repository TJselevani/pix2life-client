import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class AppTheme {
  // A helper method to create borders for input fields
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

  // Define the light theme
  static final lightThemeMode = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins', // Global font family
    primaryColor: AppPalette.redColor1,
    scaffoldBackgroundColor: AppPalette.appLightThemeBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.appLightThemeBackgroundColor,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      hintStyle: const TextStyle(
        color: AppPalette.greyColor0,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: AppPalette.inputBackgroundColor1,
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.greyColor3, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorColor, BorderStyle.solid),
      focusedErrorBorder:
          _borderLayout(AppPalette.blueColor5, BorderStyle.solid),
    ),
  );

  // Define the dark theme
  static final darkThemeMode = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins', // Global font family
    primaryColor: AppPalette.redColor1,
    scaffoldBackgroundColor: AppPalette.appDarkThemeBackgroundColor1,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.appDarkThemeBackgroundColor1,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      hintStyle: const TextStyle(
        color: AppPalette.greyColor0,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: AppPalette.inputBackgroundColor1,
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.greyColor3, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorColor, BorderStyle.solid),
      focusedErrorBorder:
          _borderLayout(AppPalette.blueColor5, BorderStyle.solid),
    ),
  );

  // Define a custom theme inspired by Material You
  static final materialYouThemeMode = ThemeData(
    useMaterial3: true, // Enable Material You features
    fontFamily: 'Poppins', // Global font family
    colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.blueColor5),
    scaffoldBackgroundColor: AppPalette.inputBackgroundColor1,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.blueColor5.withOpacity(0.9),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      hintStyle: const TextStyle(
        color: AppPalette.greyColor0,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: AppPalette.inputBackgroundColor1,
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.greyColor3, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorColor, BorderStyle.solid),
      focusedErrorBorder:
          _borderLayout(AppPalette.blueColor5, BorderStyle.solid),
    ),
  );
}
