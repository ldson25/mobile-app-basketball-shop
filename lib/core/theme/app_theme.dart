import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neon,
        secondary: AppColors.neonSoft,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.4,
          height: 0.95,
        ),
        headlineLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        titleLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: const TextStyle(color: AppColors.textPrimary, height: 1.35),
        bodyMedium: const TextStyle(
          color: AppColors.textSecondary,
          height: 1.35,
        ),
        labelLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textMuted),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.neon, width: 1.6),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerColor: AppColors.border,
    );
  }
}
