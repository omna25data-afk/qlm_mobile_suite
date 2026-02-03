import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Common Text Theme using Tajawal
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.tajawalTextTheme(base).copyWith(
      displayLarge: GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      // Add other custom text styles here
    );
  }

  // Role: Legitimate Guardian (Emerald Green Theme)
  static ThemeData guardianTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF10B981), // Emerald
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
  );

  // Role: Admin (Royal Blue Theme)
  static ThemeData adminTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E40AF), // Royal Blue
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
  );

  // Role: Documentation Clerk (Amber/Gold Theme)
  static ThemeData clerkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF59E0B), // Amber
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
  );
}
