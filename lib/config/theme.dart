import 'package:flutter/material.dart';

class AppTheme {
  // Premium color palette
  static const Color primaryDark = Color(0xFF0A0F1C);
  static const Color primaryTeal = Color(0xFF00E5CF);
  static const Color accentPurple = Color(0xFFA652FF);
  static const Color accentAmber = Color(0xFFFF9F0A);
  static const Color cardGrey = Color(0xFF262D3A);

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryTeal,
    scaffoldBackgroundColor: primaryDark,
    colorScheme: ColorScheme.dark(
      primary: primaryTeal,
      secondary: accentPurple,
      background: primaryDark,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w300,
        letterSpacing: 1.2,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardGrey,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryTeal),
      ),
      hintStyle: TextStyle(color: Colors.white38),
    ),
  );

  static var bgColor;
}