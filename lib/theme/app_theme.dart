import 'package:flutter/material.dart';

class AppTheme {
  // === Spotify-Inspired Color Palette (from DESIGN (1).md) ===
  static const Color spotifyGreen     = Color(0xFF1ED760); // Brand Accent / Primary CTA
  static const Color spotifyGreenDark = Color(0xFF1DB954);

  // Dark Theme Surfaces
  static const Color nearBlack        = Color(0xFF121212); // Base Level 0 Background
  static const Color darkSurface      = Color(0xFF181818); // Level 1 Surface
  static const Color midDark          = Color(0xFF1F1F1F); // Interactive Surface / Input
  static const Color darkCard         = Color(0xFF252525); // Elevated Card Surface
  static const Color borderGray       = Color(0xFF4D4D4D);

  // Light Theme Surfaces
  static const Color lightBg          = Color(0xFFF4F4F5); // Light Canvas
  static const Color lightSurface     = Color(0xFFFFFFFF); // White Card Surface
  static const Color lightInputBg     = Color(0xFFE4E4E7);
  static const Color lightBorder      = Color(0xFFD4D4D8);

  // Text Colors
  static const Color textBase         = Color(0xFFFFFFFF); // White text for dark
  static const Color textSilver       = Color(0xFFB3B3B3); // Secondary text for dark
  static const Color textDark         = Color(0xFF121212); // Dark text for light
  static const Color subtitleDark     = Color(0xFF666666); // Secondary text for light

  // Semantic Colors
  static const Color negativeRed      = Color(0xFFF3727F); // Error / Wrong
  static const Color warningOrange    = Color(0xFFFFA42B); // Warning / Gold
  static const Color infoBlue         = Color(0xFF539DF5); // Announcement
  static const Color correctColor     = Color(0xFF1ED760); // Green Correct
  static const Color wrongColor       = Color(0xFFF3727F); // Red Wrong

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF1ED760), Color(0xFF1DB954)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient spotifyBgGradient = LinearGradient(
    colors: [Color(0xFF1F1F1F), Color(0xFF121212), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF4F4F5), Color(0xFFE4E4E7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: spotifyGreen,
      scaffoldBackgroundColor: nearBlack,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textBase),
        titleTextStyle: TextStyle(
          color: textBase,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: spotifyGreen,
        secondary: spotifyGreen,
        surface: darkSurface,
      ),
      cardColor: darkSurface,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textBase, fontFamily: 'Poppins'),
        bodyMedium: TextStyle(color: textBase, fontFamily: 'Poppins'),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: spotifyGreen,
      scaffoldBackgroundColor: lightBg,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: spotifyGreen,
        secondary: spotifyGreen,
        surface: lightSurface,
      ),
      cardColor: lightSurface,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textDark, fontFamily: 'Poppins'),
        bodyMedium: TextStyle(color: textDark, fontFamily: 'Poppins'),
      ),
    );
  }
}
