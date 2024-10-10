import 'package:flutter/material.dart';

class MyThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default theme
  bool _useMaterialYou = false; // Flag for Material You

  ThemeMode get themeMode => _themeMode;
  bool get useMaterialYou => _useMaterialYou;

  // Check if current theme is dark mode
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get isLightMode => _themeMode == ThemeMode.light;

  void toggleTheme() {
    if (_useMaterialYou) {
      _useMaterialYou = false;
    } else {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  void setMaterialYouTheme() {
    _useMaterialYou = true;
    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _useMaterialYou = false;
    notifyListeners();
  }
}
