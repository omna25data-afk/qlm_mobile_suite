/// QLM Mobile Suite - App Shadows
/// Consistent elevation shadows for cards and UI elements

import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // ══════════════════════════════════════════════════════════════════════════
  // STANDARD SHADOWS
  // ══════════════════════════════════════════════════════════════════════════
  
  /// No shadow (flat)
  static List<BoxShadow> get none => [];

  /// Subtle shadow for cards
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Default shadow for elevated cards
  static List<BoxShadow> get md => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Prominent shadow for modals/dialogs
  static List<BoxShadow> get lg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Strong shadow for floating elements
  static List<BoxShadow> get xl => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // COLORED SHADOWS (for buttons/accents)
  // ══════════════════════════════════════════════════════════════════════════
  
  /// Colored glow shadow
  static List<BoxShadow> colored(Color color, {double intensity = 0.3}) => [
    BoxShadow(
      color: color.withValues(alpha: intensity),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // DARK MODE SHADOWS
  // ══════════════════════════════════════════════════════════════════════════
  
  /// Subtle shadow for dark mode
  static List<BoxShadow> get darkSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Default shadow for dark mode
  static List<BoxShadow> get darkMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
