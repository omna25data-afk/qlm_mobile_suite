import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color royalBlue = Color(0xFF1E40AF);
  static const Color amberGold = Color(0xFFD97706);
  static const Color deepBackground = Color(0xFFF8FAFC);
  static const String fontName = 'Tajawal';

  // --- Theme Builders ---

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: TextStyle(fontFamily: fontName, fontSize: 32, fontWeight: FontWeight.w900, color: textColor, letterSpacing: -1.0),
      displayMedium: TextStyle(fontFamily: fontName, fontSize: 28, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5),
      displaySmall: TextStyle(fontFamily: fontName, fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      headlineLarge: TextStyle(fontFamily: fontName, fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontFamily: fontName, fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
      headlineSmall: TextStyle(fontFamily: fontName, fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: TextStyle(fontFamily: fontName, fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
      titleMedium: TextStyle(fontFamily: fontName, fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
      titleSmall: TextStyle(fontFamily: fontName, fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
      bodyLarge: TextStyle(fontFamily: fontName, fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
      bodyMedium: TextStyle(fontFamily: fontName, fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
      bodySmall: TextStyle(fontFamily: fontName, fontSize: 12, fontWeight: FontWeight.normal, color: textColor.withValues(alpha: 0.7)),
      labelLarge: TextStyle(fontFamily: fontName, fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
      labelMedium: TextStyle(fontFamily: fontName, fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      labelSmall: TextStyle(fontFamily: fontName, fontSize: 11, fontWeight: FontWeight.w500, color: textColor.withValues(alpha: 0.7)),
    );
  }

  static InputDecorationTheme _buildInputTheme(ColorScheme colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.outline.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.outline.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.error),
      ),
      labelStyle: TextStyle(
        fontFamily: fontName,
        color: colors.onSurfaceVariant,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        fontFamily: fontName,
        color: colors.onSurfaceVariant.withValues(alpha: 0.5),
        fontSize: 14,
      ),
    );
  }

  static ElevatedButtonThemeData _buildButtonTheme(ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: fontName,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme colors) {
    return CardThemeData(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.08)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  static AppBarTheme _buildAppBarTheme(ColorScheme colors) {
    return AppBarTheme(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      titleTextStyle: TextStyle(
        fontFamily: fontName,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: colors.onSurface,
      ),
      iconTheme: IconThemeData(color: colors.onSurface),
    );
  }

  // --- Role Based Policies ---

  static ThemeData _createTheme(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: deepBackground,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: deepBackground,
      fontFamily: fontName,
      textTheme: _buildTextTheme(ThemeData.light().textTheme, Colors.black87),
      appBarTheme: _buildAppBarTheme(colorScheme),
      inputDecorationTheme: _buildInputTheme(colorScheme),
      elevatedButtonTheme: _buildButtonTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
    );
  }

  // Role: Legitimate Guardian (Emerald Green)
  static ThemeData guardianTheme = _createTheme(emeraldGreen);

  // Role: Admin (Royal Blue)
  static ThemeData adminTheme = _createTheme(royalBlue);

  // Role: Documentation Clerk (Amber/Gold)
  static ThemeData clerkTheme = _createTheme(amberGold);
}
