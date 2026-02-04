import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/core/presentation/app_state_manager.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/screens/login_screen.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_list_screen.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const Center(child: Text('الأمناء - قيد التنفيذ')),
    const RegistryListScreen(), // Use existing RegistryList
    const Center(child: Text('التقارير - قيد التنفيذ')),
    const Center(child: Text('الأدوات - قيد التنفيذ')),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;
    
    // Date Formatting
    final now = DateTime.now();
    final gregorianDate = DateFormat('yyyy-MM-dd').format(now);
    final hijriDate = HijriCalendar.now().toFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          flexibleSpace: Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Welcome Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أهلاً بك، ${user?.name ?? "المدير"}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppStateManager.getRoleTitle(user?.role ?? 'admin'),
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    // Action Icons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {},
                        ),
                        _buildProfileMenu(context),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Date Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        '$hijriDate هـ - $gregorianDate م',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'الأمناء'),
          BottomNavigationBarItem(icon: Icon(Icons.description_rounded), label: 'السجلات'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'التقارير'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_suggest_rounded), label: 'الأدوات'),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    final appStateManager = context.read<AppStateManager>();
    final authViewModel = context.read<AuthViewModel>();

    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage('assets/images/placeholder_profile.png'), // Need to add asset
        backgroundColor: Colors.white24,
      ),
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            break;
          case 'settings':
            break;
          case 'theme':
            appStateManager.toggleTheme();
            break;
          case 'logout':
            await authViewModel.logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'profile', child: ListTile(leading: Icon(Icons.person_outline), title: Text('الملف التعريفي'))),
        const PopupMenuItem(value: 'settings', child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('الإعدادات'))),
        PopupMenuItem(
          value: 'theme', 
          child: ListTile(
            leading: Icon(appStateManager.themeMode == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined), 
            title: const Text('تبديل المظهر'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'logout', child: ListTile(leading: Icon(Icons.logout_rounded, color: Colors.red), title: Text('تسجيل الخروج', style: TextStyle(color: Colors.red)))),
      ],
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard('إجمالي القيود اليوم', '124', Colors.blue),
          const SizedBox(height: 12),
          _buildStatCard('الأمناء النشطون', '15', Colors.green),
          const SizedBox(height: 12),
          _buildStatCard('قيود معلقة للمراجعة', '8', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
