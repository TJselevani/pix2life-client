import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppTheme {
  static OutlineInputBorder _borderLayout(
          [Color color = AppPalette.transparent,
          BorderStyle style = BorderStyle.none]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1, style: style),
        borderRadius: BorderRadius.circular(10),
      );

  // Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppPalette.red,
    scaffoldBackgroundColor: AppPalette.lightBackground,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.lightBackground,
      titleTextStyle: TextStyle(
          color: AppPalette.primaryBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppPalette.primaryBlack),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppPalette.primaryBlack, fontSize: 14),
      bodyMedium: TextStyle(color: AppPalette.primaryBlack, fontSize: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.inputBackground,
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.primaryGrey, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorRed, BorderStyle.solid),
    ),
  );

  // Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppPalette.red,
    scaffoldBackgroundColor: AppPalette.darkBackground,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.darkBackground,
      titleTextStyle: TextStyle(
          color: AppPalette.fontWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppPalette.fontWhite),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppPalette.fontWhite, fontSize: 14),
      bodyMedium: TextStyle(color: AppPalette.fontWhite, fontSize: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.inputBackground,
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.primaryGrey, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorRed, BorderStyle.solid),
    ),
  );

  // Material You Theme
  static final materialYouTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.blueAccent),
    scaffoldBackgroundColor: AppPalette.inputBackground,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.blueAccent.withOpacity(0.9),
      titleTextStyle: const TextStyle(
          color: AppPalette.fontWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: AppPalette.fontWhite),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppPalette.primaryBlack, fontSize: 14),
      bodyMedium: TextStyle(color: AppPalette.primaryBlack, fontSize: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.inputBackground,
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.primaryGrey, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorRed, BorderStyle.solid),
    ),
  );
}
