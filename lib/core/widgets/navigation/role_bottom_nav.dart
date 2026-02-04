/// QLM Mobile Suite - Role Based Bottom Navigation
/// Handles different navigation for Admin and Guardian roles

import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_text_styles.dart';

/// User role types
enum UserRole {
  admin,
  guardian,
}

/// Navigation item definition
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

class RoleBottomNav extends StatelessWidget {
  const RoleBottomNav({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  final UserRole role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Admin navigation items
  static const List<NavItem> adminItems = [
    NavItem(
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItem(
      label: 'الأمناء',
      icon: Icons.people_outline,
      activeIcon: Icons.people,
    ),
    NavItem(
      label: 'السجلات',
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
    ),
    NavItem(
      label: 'التقارير',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
    ),
    NavItem(
      label: 'الأدوات',
      icon: Icons.build_outlined,
      activeIcon: Icons.build,
    ),
  ];

  /// Guardian navigation items
  static const List<NavItem> guardianItems = [
    NavItem(
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItem(
      label: 'سجلاتي',
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
    ),
    NavItem(
      label: 'إضافة قيد',
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
    ),
    NavItem(
      label: 'التقارير',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
    ),
    NavItem(
      label: 'الأدوات',
      icon: Icons.build_outlined,
      activeIcon: Icons.build,
    ),
  ];

  List<NavItem> get _items =>
      role == UserRole.admin ? adminItems : guardianItems;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (index) => _NavBarItem(
                item: _items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                // Highlight the center "add" button for guardian
                isSpecial: role == UserRole.guardian && index == 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.isSpecial = false,
  });

  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSpecial;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Special styling for "Add Entry" button (Guardian)
    if (isSpecial) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            item.activeIcon,
            color: colorScheme.onPrimary,
            size: 28,
          ),
        ),
      );
    }

    final color = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
