/// QLM Mobile Suite - App Colors
/// Semantic color tokens for consistent theming across the app

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ══════════════════════════════════════════════════════════════════════════
  // BRAND COLORS
  // ══════════════════════════════════════════════════════════════════════════
  
  /// Guardian Role - Emerald Green
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFF34D399);
  static const Color emeraldDark = Color(0xFF059669);

  /// Admin Role - Royal Blue
  static const Color royalBlue = Color(0xFF1E40AF);
  static const Color royalLight = Color(0xFF3B82F6);
  static const Color royalDark = Color(0xFF1E3A8A);

  /// Clerk Role - Amber Gold
  static const Color amberGold = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFBBF24);
  static const Color amberDark = Color(0xFFB45309);

  // ══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS (Status from API)
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ══════════════════════════════════════════════════════════════════════════
  // NEUTRAL COLORS
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);

  // ══════════════════════════════════════════════════════════════════════════
  // BACKGROUND COLORS
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  // ══════════════════════════════════════════════════════════════════════════
  // STATUS COLOR MAP (للربط مع API)
  // ══════════════════════════════════════════════════════════════════════════
  
  static const Map<String, Color> statusColors = {
    'success': success,
    'warning': warning,
    'danger': danger,
    'info': info,
    'active': success,
    'expired': danger,
    'pending': warning,
    'closed': neutral500,
  };

  /// Get color from API status string
  static Color fromStatus(String? status) {
    return statusColors[status?.toLowerCase()] ?? neutral500;
  }

  /// Get light version of status color (for backgrounds)
  static Color fromStatusLight(String? status) {
    return fromStatus(status).withValues(alpha: 0.1);
  }
}
