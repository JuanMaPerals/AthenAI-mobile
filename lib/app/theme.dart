import 'package:flutter/material.dart';

// Primary Green Palette
const Color persalOneGreen = Color(0xFF205030); // Main brand green
const Color persalOneGreenDark = Color(0xFF163822); // Darker green
const Color persalOneGreenSoft = Color(0xFF6E8D78); // Softer green
const Color persalOneGreenLight = Color(0xFFD2DCD6); // Very light green/grey

// Accent Gold Palette
const Color persalOneGold = Color(0xFFC09030); // Main accent gold
const Color persalOneGoldSoft = Color(0xFFD6B778); // Softer gold
const Color persalOneGoldLight = Color(0xFFF2E9D6); // Warm light background

// Neutrals
const Color persalOneBg = Colors.white;
const Color persalOneTextMain = Color(0xFF111111);
const Color persalOneTextMuted = Color(0xFF555555);
const Color persalOneBorder = Color(0xFFE3E3E3);

ThemeData buildPersalOneTheme() {
  final base = ThemeData.light();

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: persalOneGreen,
    onPrimary: Colors.white,
    secondary: persalOneGold,
    onSecondary: Colors.white,
    error: const Color(0xFFD32F2F),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: persalOneTextMain,
    outline: persalOneBorder,
  );

  return base.copyWith(
    colorScheme: colorScheme,
    primaryColor: persalOneGreen,
    scaffoldBackgroundColor: persalOneBg,
    
    // Typography
    textTheme: base.textTheme.apply(
      bodyColor: persalOneTextMain,
      displayColor: persalOneGreenDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: persalOneGreenDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: persalOneGreenDark,
      ),
      iconTheme: IconThemeData(color: persalOneGreenDark),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: persalOneGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: persalOneGreen,
        side: const BorderSide(color: persalOneGreen),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: persalOneGreen,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: persalOneBorder),
      ),
      margin: const EdgeInsets.only(bottom: 16),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: persalOneBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: persalOneBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: persalOneGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: persalOneTextMuted),
    ),
  );
}

/// High contrast theme variant for improved accessibility
/// Uses WCAG AA compliant contrast ratios
ThemeData buildHighContrastTheme() {
  final base = ThemeData.light();

  // High contrast color scheme
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF1B5E20), // Darker green for better contrast
    onPrimary: Colors.white,
    secondary: const Color(0xFF967117), // Darker gold for better contrast
    onSecondary: Colors.white,
    error: const Color(0xFFC62828), // Darker red
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    outline: Colors.black54,
  );

  return base.copyWith(
    colorScheme: colorScheme,
    primaryColor: const Color(0xFF1B5E20),
    scaffoldBackgroundColor: Colors.white,
    
    textTheme: base.textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1B5E20),
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1B5E20),
        side: const BorderSide(color: Color(0xFF1B5E20), width: 2),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black26, width: 1),
      ),
    ),
  );
}
