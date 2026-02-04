/// Guardian Tools Screen
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';

class GuardianToolsScreen extends StatelessWidget {
  const GuardianToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأدوات المساعدة',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          _ToolCard(
            icon: Icons.calendar_today,
            title: 'تحويل التواريخ',
            subtitle: 'ميلادي ↔ هجري',
            onTap: () {},
          ),
          _ToolCard(
            icon: Icons.calculate,
            title: 'حاسبة الرسوم',
            subtitle: 'حساب رسوم العقود',
            onTap: () {},
          ),
          _ToolCard(
            icon: Icons.search,
            title: 'البحث السريع',
            subtitle: 'البحث في القيود',
            onTap: () {},
          ),
          _ToolCard(
            icon: Icons.qr_code_scanner,
            title: 'ماسح QR',
            subtitle: 'قراءة رموز QR',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.listItemGap),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.neutral400,
        ),
        onTap: onTap,
      ),
    );
  }
}
