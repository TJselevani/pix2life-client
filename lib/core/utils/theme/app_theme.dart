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
  static final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: AppPalette.red,
    indicatorColor: AppPalette.red,
    scaffoldBackgroundColor: AppPalette.lightBackground,
    // fontFamily: 'Poppins',
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppPalette.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.lightBackground,
      titleTextStyle: TextStyle(
          color: AppPalette.primaryBlack,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppPalette.primaryBlack),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: AppPalette.primaryBlack, fontFamily: 'Poppins', fontSize: 14),
      bodyMedium: TextStyle(
          color: AppPalette.primaryBlack, fontFamily: 'Poppins', fontSize: 16),
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
  static final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: AppPalette.red,
    scaffoldBackgroundColor: AppPalette.darkBackground,
    // fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.darkBackground,
      titleTextStyle: TextStyle(
          color: AppPalette.fontWhite,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppPalette.fontWhite),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: AppPalette.fontWhite, fontFamily: 'Poppins', fontSize: 14),
      bodyMedium: TextStyle(
          color: AppPalette.fontWhite, fontFamily: 'Poppins', fontSize: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.lightBackground.withOpacity(.1),
      border: InputBorder.none,
      hintStyle: const TextStyle(
        color: Colors.black54,
        fontFamily: 'Poppins',
      ), // Darker hint text color
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(AppPalette.primaryGrey, BorderStyle.solid),
      errorBorder: _borderLayout(AppPalette.errorRed, BorderStyle.solid),
      labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Poppins'), // Input text color
    ),
  );

  // Material You Light Theme
  static final materialYouTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light, // Ensure it's treated as a light theme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light, // Set light mode explicitly
    ),
    scaffoldBackgroundColor: AppPalette.lightBackground,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo.withOpacity(0.9),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 14),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: InputBorder.none,
      enabledBorder: _borderLayout(),
      focusedBorder: _borderLayout(Colors.grey, BorderStyle.solid),
      errorBorder: _borderLayout(Colors.redAccent, BorderStyle.solid),
    ),
  );
}
