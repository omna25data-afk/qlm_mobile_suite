/// Tools Screen - Various utilities and services
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأدوات والخدمات',
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
            title: 'حاسبة المواريث',
            subtitle: 'الحساب الشرعي للمواريث',
            onTap: () {},
          ),
          _ToolCard(
            icon: Icons.block,
            title: 'القائمة السوداء',
            subtitle: 'قائمة الممنوعين',
            onTap: () {},
          ),
          _ToolCard(
            icon: Icons.backup,
            title: 'النسخ الاحتياطي',
            subtitle: 'تصدير واستيراد البيانات',
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
