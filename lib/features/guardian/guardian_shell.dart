/// QLM Mobile Suite - Guardian Shell
/// Main container for Guardian (الأمين الشرعي) interface

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/core/widgets/app_bar/main_app_bar.dart';
import 'package:qlm_mobile_suite/core/widgets/navigation/role_bottom_nav.dart';
import 'package:qlm_mobile_suite/core/presentation/app_state_manager.dart';
import 'package:qlm_mobile_suite/features/guardian/home/screens/guardian_home_screen.dart';
import 'package:qlm_mobile_suite/features/guardian/my_records/screens/my_records_screen.dart';
import 'package:qlm_mobile_suite/features/guardian/add_entry/screens/add_entry_screen.dart';
import 'package:qlm_mobile_suite/features/guardian/reports/screens/guardian_reports_screen.dart';
import 'package:qlm_mobile_suite/features/guardian/tools/screens/guardian_tools_screen.dart';

class GuardianShell extends StatefulWidget {
  const GuardianShell({super.key});

  @override
  State<GuardianShell> createState() => _GuardianShellState();
}

class _GuardianShellState extends State<GuardianShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    GuardianHomeScreen(),
    MyRecordsScreen(),
    AddEntryScreen(),
    GuardianReportsScreen(),
    GuardianToolsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateManager>();

    return Scaffold(
      appBar: MainAppBar(
        userName: appState.currentUser?.name ?? 'الأمين',
        userRole: 'الأمين الشرعي',
        dateHijri: _getHijriDate(),
        notificationCount: 2, // TODO: من API
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
        role: UserRole.guardian,
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
