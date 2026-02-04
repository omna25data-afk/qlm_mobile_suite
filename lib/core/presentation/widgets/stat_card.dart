/// QLM Mobile Suite - Stat Card
/// Dashboard statistics card with icon and value

import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_text_styles.dart';
import 'package:qlm_mobile_suite/core/theme/app_shadows.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
    this.onTap,
  });

  /// Card title (e.g., "إجمالي القيود")
  final String title;

  /// Main value to display (e.g., "150")
  final String value;

  /// Icon for the stat
  final IconData icon;

  /// Accent color (defaults to primary)
  final Color? color;

  /// Optional subtitle (e.g., "هذا الشهر: 12")
  final String? subtitle;

  /// Optional tap handler
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = color ?? colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: isDark ? AppShadows.darkSm : AppShadows.sm,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: AppSpacing.iconMd,
                  ),
                ),
                const Spacer(),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.neutral400,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Value
            Text(
              value,
              style: AppTextStyles.displayMedium.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Title
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral500,
              ),
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: AppTextStyles.labelSmall.copyWith(
                  color: accentColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Grid of stat cards
class StatCardGrid extends StatelessWidget {
  const StatCardGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
  });

  final List<StatCard> children;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.1,
      children: children,
    );
  }
}
