import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isLightMode => _themeMode == ThemeMode.light;

  ThemeService() {
    AppColors.isLightMode = isLightMode;
  }

  void setLightMode(bool value) {
    _themeMode = value ? ThemeMode.light : ThemeMode.dark;
    AppColors.isLightMode = value;
    notifyListeners();
  }
}
