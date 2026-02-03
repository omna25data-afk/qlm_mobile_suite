import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_list_screen.dart';

class GuardianDashboardScreen extends StatelessWidget {
  const GuardianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: const EdgeInsets.all(16),
      children: [
        _buildMenuCard(context, 'السجلات', Icons.book_rounded, Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistryListScreen()));
        }),
        _buildMenuCard(context, 'القيود الجديدة', Icons.add_circle_outline, Colors.blue, () {}),
        _buildMenuCard(context, 'المزامنة', Icons.sync_rounded, Colors.orange, () {}),
        _buildMenuCard(context, 'الإحصائيات', Icons.bar_chart_rounded, Colors.purple, () {}),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
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
