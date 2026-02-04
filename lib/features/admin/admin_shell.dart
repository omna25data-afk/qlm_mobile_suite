/// QLM Mobile Suite - Admin Shell
/// Main container for Admin interface with bottom navigation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/core/widgets/app_bar/main_app_bar.dart';
import 'package:qlm_mobile_suite/core/widgets/navigation/role_bottom_nav.dart';
import 'package:qlm_mobile_suite/core/presentation/app_state_manager.dart';
import 'package:qlm_mobile_suite/features/admin/home/screens/admin_home_screen.dart';
import 'package:qlm_mobile_suite/features/admin/guardians/screens/guardians_screen.dart';
import 'package:qlm_mobile_suite/features/admin/records/screens/records_screen.dart';
import 'package:qlm_mobile_suite/features/admin/reports/screens/reports_screen.dart';
import 'package:qlm_mobile_suite/features/admin/tools/screens/tools_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AdminHomeScreen(),
    GuardiansScreen(),
    RecordsScreen(),
    ReportsScreen(),
    ToolsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateManager>();

    return Scaffold(
      appBar: MainAppBar(
        userName: appState.currentUser?.name ?? 'المستخدم',
        userRole: 'مدير النظام',
        dateHijri: _getHijriDate(),
        notificationCount: 3, // TODO: من API
        onNotificationsTap: () => _showNotifications(),
        onProfileTap: () => _navigateToProfile(),
        onSettingsTap: () => _navigateToSettings(),
        onThemeToggle: () => appState.toggleTheme(),
        onLogoutTap: () => _confirmLogout(),
        isOffline: !appState.isOnline,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: RoleBottomNav(
        role: UserRole.admin,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  String _getHijriDate() {
    // TODO: استخدام مكتبة hijri
    return '9 شعبان 1447 هـ';
  }

  void _showNotifications() {
    // TODO: عرض شاشة الإشعارات
  }

  void _navigateToProfile() {
    // TODO: الانتقال للملف الشخصي
  }

  void _navigateToSettings() {
    // TODO: الانتقال للإعدادات
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تنفيذ تسجيل الخروج
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
