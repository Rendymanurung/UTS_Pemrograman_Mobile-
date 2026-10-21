import 'package:flutter/material.dart';

class AppTheme {
  // === Color Palette ===
  static const Color primaryColor    = Color(0xFF7C3AED); // Deep Violet
  static const Color accentColor     = Color(0xFFEC4899); // Hot Pink
  static const Color goldColor       = Color(0xFFF59E0B); // Amber Gold
  static const Color darkBg          = Color(0xFF0F0A1E); // Deep Dark Purple
  static const Color darkSurface     = Color(0xFF1A1030); // Dark Card
  static const Color darkCard        = Color(0xFF221840); // Slightly Lighter Card
  static const Color lightBg         = Color(0xFFF1F0FF); // Lavender White
  static const Color lightSurface    = Color(0xFFFFFFFF);
  static const Color lightCard       = Color(0xFFEDE9FE); // Soft Violet
  static const Color correctColor    = Color(0xFF10B981); // Emerald Green
  static const Color wrongColor      = Color(0xFFEF4444); // Red
  static const Color textLight       = Color(0xFFF3F4F6);
  static const Color textDark        = Color(0xFF1F2937);
  static const Color subtitleLight   = Color(0xFF9CA3AF);
  static const Color subtitleDark    = Color(0xFF6B7280);

  // === Gradients ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0F0A1E), Color(0xFF1A103A), Color(0xFF0F0A1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBg,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: const TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: lightSurface,
      ),
      cardColor: lightSurface,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textDark, fontFamily: 'Poppins'),
        bodyMedium: TextStyle(color: textDark, fontFamily: 'Poppins'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBg,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textLight),
        titleTextStyle: const TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: darkSurface,
      ),
      cardColor: darkCard,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textLight, fontFamily: 'Poppins'),
        bodyMedium: TextStyle(color: textLight, fontFamily: 'Poppins'),
      ),
    );
  }
}