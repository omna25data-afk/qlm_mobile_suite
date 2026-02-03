import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/core/presentation/app_state_manager.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/screens/login_screen.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_list_screen.dart';
import 'package:qlm_mobile_suite/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:qlm_mobile_suite/features/guardian/presentation/screens/guardian_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appStateManager = context.watch<AppStateManager>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStateManager.getRoleTitle(user?.role ?? 'guardian')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
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
      body: _buildRoleDashboard(user?.role ?? 'guardian', context),
    );
  }

  Widget _buildRoleDashboard(String role, BuildContext context) {
    switch (role) {
      case 'admin':
        return const AdminDashboardScreen();
      case 'clerk':
        return const Center(child: Text('لوحة تحكم قلم التوثيق - قيد التنفيذ'));
      default:
        return const GuardianDashboardScreen();
    }
  }
}
