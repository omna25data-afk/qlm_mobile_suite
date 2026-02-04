import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color royalBlue = Color(0xFF1E40AF);
  static const Color amberGold = Color(0xFFD97706);
  static const Color deepBackground = Color(0xFFF8FAFC);

  // Common Text Theme using Tajawal
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return GoogleFonts.tajawalTextTheme(base).copyWith(
      displayLarge: GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.tajawal(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor.withValues(alpha: 0.8),
      ),
      labelLarge: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  // Role: Legitimate Guardian (Emerald Green Theme)
  static ThemeData guardianTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: emeraldGreen,
      brightness: Brightness.light,
      surface: deepBackground,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme, Colors.black87),
    scaffoldBackgroundColor: deepBackground,
  );

  // Role: Admin (Royal Blue Theme)
  static ThemeData adminTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: royalBlue,
      brightness: Brightness.light,
      surface: deepBackground,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme, Colors.black87),
    scaffoldBackgroundColor: deepBackground,
  );

  // Role: Documentation Clerk (Amber/Gold Theme)
  static ThemeData clerkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: amberGold,
      brightness: Brightness.light,
      surface: deepBackground,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme, Colors.black87),
    scaffoldBackgroundColor: deepBackground,
  );
}
