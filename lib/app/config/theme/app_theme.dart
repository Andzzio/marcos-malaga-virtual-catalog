import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xff7A2E3B);
  static const Color scaffoldBackground = Color(0xFFFAFAF9);
  static const Color accentColor = Color(0xffaf8026); // Dorado Clásico
  static const Color textColor = Color(0xFF0C0A09);
  static const Color mutedColor = Color(0xFFE8ECF0);
  static const Color deadColor = Color(0xFFEBEBEB);

  static const Color success = Color(0xFF3ED660);
  static const Color error = Color(0xFFDC2626);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: scaffoldBackground,
        error: error,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade400),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.instrumentSerif(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        displayMedium: GoogleFonts.instrumentSans(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: GoogleFonts.instrumentSans(color: textColor, fontSize: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.instrumentSans(fontWeight: FontWeight.w500),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        titleTextStyle: GoogleFonts.instrumentSans(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        hintStyle: TextStyle(
          color: Colors.black.withValues(alpha: 0.4),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
      ),
    );
  }
}
