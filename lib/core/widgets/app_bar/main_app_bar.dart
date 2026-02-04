/// QLM Mobile Suite - Main App Bar
/// Shared app bar with welcome message, notifications, and user menu

import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_text_styles.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.userName,
    required this.userRole,
    required this.dateHijri,
    this.notificationCount = 0,
    this.avatarUrl,
    this.onNotificationsTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.onThemeToggle,
    this.onLogoutTap,
    this.isOffline = false,
  });

  /// User's display name
  final String userName;

  /// User's role label (e.g., "الأمين الشرعي", "مدير النظام")
  final String userRole;

  /// Hijri date string (e.g., "9 شعبان 1447 هـ")
  final String dateHijri;

  /// Unread notification count
  final int notificationCount;

  /// User avatar URL (null for default)
  final String? avatarUrl;

  /// Callbacks
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onLogoutTap;

  /// Offline indicator
  final bool isOffline;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final greeting = _getGreeting();

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: AppSpacing.screenHorizontal,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting with name
          Text(
            '$greeting، $userName',
            style: AppTextStyles.titleMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          // Role and date
          Row(
            children: [
              Text(
                userRole,
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '•',
                style: TextStyle(color: AppColors.neutral400),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                dateHijri,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
              // Offline indicator
              if (isOffline) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 10,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'غير متصل',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.warning,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      actions: [
        // Notifications button with badge
        _NotificationButton(
          count: notificationCount,
          onTap: onNotificationsTap,
        ),
        const SizedBox(width: AppSpacing.sm),

        // User avatar with dropdown menu
        _UserMenu(
          avatarUrl: avatarUrl,
          userName: userName,
          onProfileTap: onProfileTap,
          onSettingsTap: onSettingsTap,
          onThemeToggle: onThemeToggle,
          onLogoutTap: onLogoutTap,
        ),
        const SizedBox(width: AppSpacing.screenHorizontal - 8),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء الخير';
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.count,
    this.onTap,
  });

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onTap,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(
          count > 99 ? '99+' : count.toString(),
          style: const TextStyle(fontSize: 10),
        ),
        child: Icon(
          Icons.notifications_outlined,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _UserMenu extends StatelessWidget {
  const _UserMenu({
    this.avatarUrl,
    required this.userName,
    this.onProfileTap,
    this.onSettingsTap,
    this.onThemeToggle,
    this.onLogoutTap,
  });

  final String? avatarUrl;
  final String userName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onLogoutTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? Text(
                userName.isNotEmpty ? userName[0] : '?',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.primary,
                ),
              )
            : null,
      ),
      itemBuilder: (context) => [
        _buildMenuItem(
          context,
          value: 'profile',
          icon: Icons.person_outline,
          label: 'الملف الشخصي',
        ),
        _buildMenuItem(
          context,
          value: 'settings',
          icon: Icons.settings_outlined,
          label: 'الإعدادات',
        ),
        _buildMenuItem(
          context,
          value: 'theme',
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          label: isDark ? 'الوضع الفاتح' : 'الوضع الداكن',
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          context,
          value: 'logout',
          icon: Icons.logout,
          label: 'تسجيل الخروج',
          isDestructive: true,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfileTap?.call();
            break;
          case 'settings':
            onSettingsTap?.call();
            break;
          case 'theme':
            onThemeToggle?.call();
            break;
          case 'logout':
            onLogoutTap?.call();
            break;
        }
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? AppColors.danger : Theme.of(context).colorScheme.onSurface;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
