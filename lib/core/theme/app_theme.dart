import 'package:flutter/material.dart';

abstract class AppTheme {
  static const Color _primaryLight = Color(0xFF4F46E5);
  static const Color _secondaryLight = Color(0xFF0EA5E9);
  static const Color _backgroundLight = Color(0xFFF8FAFC);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _errorLight = Color(0xFFEF4444);

  static const Color _primaryDark = Color(0xFF818CF8);
  static const Color _secondaryDark = Color(0xFF38BDF8);
  static const Color _backgroundDark = Color(0xFF0F172A);
  static const Color _surfaceDark = Color(0xFF1E293B);
  static const Color _errorDark = Color(0xFFF87171);

  /// Theme Clair
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: _primaryLight,
      secondary: _secondaryLight,
      surface: _surfaceLight,
      error: _errorLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF0F172A),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundLight,

      fontFamily: 'Poppins',

      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFF0F172A)),
        titleTextStyle: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: _surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _errorLight),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color(0xFF1E293B),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  /// Theme Sombre
  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      primary: _primaryDark,
      secondary: _secondaryDark,
      surface: _surfaceDark,
      error: _errorDark,
      onPrimary: Color(0xFF0F172A),
      onSecondary: Color(0xFF0F172A),
      onSurface: Color(0xFFF8FAFC),
      onError: Color(0xFF0F172A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundDark,

      fontFamily: 'Poppins',

      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
        titleTextStyle: TextStyle(
          color: Color(0xFFF8FAFC),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _errorDark),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: const Color(0xFF0F172A),
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        contentTextStyle: const TextStyle(color: Color(0xFF0F172A)),
      ),
    );
  }
}