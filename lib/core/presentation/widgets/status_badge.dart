/// QLM Mobile Suite - Status Badge
/// Displays status labels with colors from API (success, warning, danger)

import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.status,
    this.icon,
    this.size = StatusBadgeSize.medium,
  });

  /// The display text (e.g., "سارية", "منتهية")
  final String label;

  /// Status key from API (e.g., "success", "danger", "warning")
  final String status;

  /// Optional leading icon
  final IconData? icon;

  /// Badge size variant
  final StatusBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.fromStatus(status);
    final bgColor = AppColors.fromStatusLight(status);

    final padding = switch (size) {
      StatusBadgeSize.small => const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
      StatusBadgeSize.medium => const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      StatusBadgeSize.large => const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
    };

    final textStyle = switch (size) {
      StatusBadgeSize.small => AppTextStyles.labelSmall,
      StatusBadgeSize.medium => AppTextStyles.labelMedium,
      StatusBadgeSize.large => AppTextStyles.labelLarge,
    };

    final iconSize = switch (size) {
      StatusBadgeSize.small => 12.0,
      StatusBadgeSize.medium => 14.0,
      StatusBadgeSize.large => 16.0,
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: iconSize),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: textStyle.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

enum StatusBadgeSize { small, medium, large }
