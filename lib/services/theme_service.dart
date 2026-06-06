import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isLightMode => _themeMode == ThemeMode.light;

  void setLightMode(bool value) {
    _themeMode = value ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
