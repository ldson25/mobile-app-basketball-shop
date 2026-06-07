import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7F7F3),
      colorScheme: ColorScheme.light(
        primary: AppColors.neon,
        secondary: Color(0xFF2F5A00),
        surface: Colors.white,
        error: AppColors.error,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          color: Color(0xFF111111),
          fontWeight: FontWeight.w900,
          height: 0.95,
        ),
        headlineLarge: const TextStyle(
          color: Color(0xFF111111),
          fontWeight: FontWeight.w900,
        ),
        titleLarge: const TextStyle(
          color: Color(0xFF111111),
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: const TextStyle(color: Color(0xFF111111), height: 1.35),
        bodyMedium: const TextStyle(color: Color(0xFF555555), height: 1.35),
        labelLarge: const TextStyle(
          color: Color(0xFF111111),
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF111111),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Color(0xFF777777)),
        labelStyle: TextStyle(color: Color(0xFF555555)),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0D0D0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.neon, width: 1.6),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0D0D0)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerColor: const Color(0xFFD0D0D0),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.neon,
        secondary: AppColors.neonSoft,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.4,
          height: 0.95,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimary, height: 1.35),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          height: 1.35,
        ),
        labelLarge: TextStyle(
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
      inputDecorationTheme: InputDecorationTheme(
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
