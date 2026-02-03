import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/core/presentation/app_state_manager.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/screens/login_screen.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stateManager = context.watch<AppStateManager>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStateManager.getRoleTitle(stateManager.currentRole)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أهلاً بك، ${user?.name ?? 'مستخدم'}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'أنت الآن في لوحة التحكم الخاصة بـ ${AppStateManager.getRoleTitle(stateManager.currentRole)}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            
            // Role-specific Widgets
            Expanded(
              child: _buildRoleDashboard(stateManager.currentRole, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleDashboard(String role, BuildContext context) {
    switch (role) {
      case 'admin':
        return _buildAdminDashboard();
      case 'clerk':
        return _buildClerkDashboard();
      default:
        return _buildGuardianDashboard(context);
    }
  }

  Widget _buildAdminDashboard() {
    return const Center(child: Text('لوحة تحكم المدير - قيد التنفيذ'));
  }

  Widget _buildClerkDashboard() {
    return const Center(child: Text('لوحة تحكم قلم التوثيق - قيد التنفيذ'));
  }

  Widget _buildGuardianDashboard(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _buildMenuCard('السجلات', Icons.book_rounded, Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistryListScreen()));
        }),
        _buildMenuCard('القيود الجديدة', Icons.add_circle_outline, Colors.blue, () {}),
        _buildMenuCard('المزامنة', Icons.sync_rounded, Colors.orange, () {}),
        _buildMenuCard('الإحصائيات', Icons.bar_chart_rounded, Colors.purple, () {}),
      ],
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
