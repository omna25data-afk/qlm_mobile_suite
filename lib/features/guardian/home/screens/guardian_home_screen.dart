/// Guardian Home Screen (Dashboard)
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/stat_card.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/status_badge.dart';

class GuardianHomeScreen extends StatelessWidget {
  const GuardianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // License status card
          _LicenseStatusCard(),
          const SizedBox(height: AppSpacing.lg),

          // Stats Grid
          StatCardGrid(
            children: [
              StatCard(
                title: 'إجمالي القيود',
                value: '150',
                icon: Icons.article,
                color: AppColors.emeraldGreen,
                subtitle: 'هذا الشهر: 12',
              ),
              StatCard(
                title: 'المسودات',
                value: '5',
                icon: Icons.edit_note,
                color: AppColors.amberGold,
              ),
              StatCard(
                title: 'الموثقة',
                value: '140',
                icon: Icons.verified,
                color: AppColors.royalBlue,
              ),
              StatCard(
                title: 'السجلات',
                value: '4',
                icon: Icons.book,
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Recent activities
          Text(
            'آخر القيود',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          // TODO: Add recent entries list
        ],
      ),
    );
  }
}

class _LicenseStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حالة الترخيص',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const StatusBadge(
                label: 'سارية',
                status: 'success',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'ينتهي في: 20 جمادى الأولى 1448 هـ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'متبقي: 450 يوم',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
