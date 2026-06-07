import 'package:flutter/material.dart';

class AppColors {
  static bool isLightMode = false;

  static Color get background => isLightMode ? const Color(0xFFF7F7F3) : const Color(0xFF0E0E0E);

  static Color get surface => isLightMode ? Colors.white : const Color(0xFF131313);
  static Color get surface2 => isLightMode ? const Color(0xFFF0F0F0) : const Color(0xFF191919);
  static Color get surface3 => isLightMode ? const Color(0xFFE5E5E5) : const Color(0xFF262626);
  static Color get surfaceHighest => surface3;

  static Color get outline => isLightMode ? const Color(0xFFD0D0D0) : const Color(0xFF484848);
  static Color get border => outline;

  static Color get textPrimary => isLightMode ? const Color(0xFF111111) : Colors.white;
  static Color get textSecondary => isLightMode ? const Color(0xFF555555) : const Color(0xFFABABAB);
  static Color get textMuted => textSecondary;

  static Color get volt => const Color(0xFFCCFD00);
  static Color get neon => isLightMode ? const Color(0xFF2F5A00) : volt;

  static Color get voltSoft => const Color(0x1ACCFF00);
  static Color get neonSoft => voltSoft;

  static Color get danger => const Color(0xFFFF7351);
  static Color get error => danger;

  static Color get warning => const Color(0xFFF7DA41);
  static Color get success => volt;
}
