/// QLM Mobile Suite - Empty State
/// Consistent empty state display for lists and screens

import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
  });

  /// Large icon to display
  final IconData icon;

  /// Main message title
  final String title;

  /// Optional subtitle/description
  final String? subtitle;

  /// Optional action callback
  final VoidCallback? action;

  /// Label for action button
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconXl,
                color: AppColors.neutral400,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: action,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined empty states for common scenarios
class EmptyStates {
  EmptyStates._();

  static Widget noRecords({VoidCallback? onAdd}) => EmptyState(
        icon: Icons.book_outlined,
        title: 'لا توجد سجلات',
        subtitle: 'لم يتم إضافة أي سجلات بعد',
        action: onAdd,
        actionLabel: 'إضافة سجل',
      );

  static Widget noEntries({VoidCallback? onAdd}) => EmptyState(
        icon: Icons.article_outlined,
        title: 'لا توجد قيود',
        subtitle: 'لم يتم إضافة أي قيود في هذا السجل',
        action: onAdd,
        actionLabel: 'إضافة قيد',
      );

  static Widget noNotifications() => const EmptyState(
        icon: Icons.notifications_none_outlined,
        title: 'لا توجد إشعارات',
        subtitle: 'ستظهر الإشعارات الجديدة هنا',
      );

  static Widget noResults() => const EmptyState(
        icon: Icons.search_off_outlined,
        title: 'لا توجد نتائج',
        subtitle: 'حاول تغيير معايير البحث',
      );

  static Widget offline() => const EmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'غير متصل',
        subtitle: 'تحقق من اتصالك بالإنترنت',
      );

  static Widget error({VoidCallback? onRetry}) => EmptyState(
        icon: Icons.error_outline,
        title: 'حدث خطأ',
        subtitle: 'تعذر تحميل البيانات',
        action: onRetry,
        actionLabel: 'إعادة المحاولة',
      );
}
