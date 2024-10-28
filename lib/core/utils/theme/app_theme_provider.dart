import 'package:flutter/material.dart';

class MyThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme
  bool _useMaterialYou = false; // Flag for Material You styling

  ThemeMode get themeMode => _themeMode;
  bool get useMaterialYou => _useMaterialYou;

  /// Returns true if the current theme is dark mode.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Returns true if the current theme is light mode.
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Toggles between light and dark mode if Material You is disabled.
  void toggleTheme() {
    if (_useMaterialYou) {
      _useMaterialYou = false; // Disable Material You to toggle manually
    } else {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  /// Enables Material You theming, overriding manual theme selection.
  void setMaterialYouTheme() {
    _useMaterialYou = true;
    notifyListeners();
  }

  /// Sets a specific theme mode (light, dark, or system) and disables Material You.
  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _useMaterialYou = false;
    notifyListeners();
  }
}
