/// Admin Home Screen (Dashboard)
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/stat_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          StatCardGrid(
            children: [
              StatCard(
                title: 'إجمالي الأمناء',
                value: '45',
                icon: Icons.people,
                color: AppColors.royalBlue,
              ),
              StatCard(
                title: 'إجمالي السجلات',
                value: '128',
                icon: Icons.book,
                color: AppColors.emeraldGreen,
              ),
              StatCard(
                title: 'قيود هذا الشهر',
                value: '342',
                icon: Icons.article,
                color: AppColors.amberGold,
              ),
              StatCard(
                title: 'تراخيص منتهية',
                value: '3',
                icon: Icons.warning,
                color: AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Recent Activities section placeholder
          Text(
            'آخر النشاطات',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          // TODO: Add recent activities list
        ],
      ),
    );
  }
}
