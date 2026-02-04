/// QLM Mobile Suite - Loading Shimmer
/// Skeleton loading states for cards and lists

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.neutral700 : AppColors.neutral200,
      highlightColor: isDark ? AppColors.neutral600 : AppColors.neutral100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSpacing.radiusSm,
          ),
        ),
      ),
    );
  }
}

/// Card shimmer for loading states
class CardShimmer extends StatelessWidget {
  const CardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LoadingShimmer(width: 48, height: 48, borderRadius: 24),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingShimmer(height: 16),
                    SizedBox(height: AppSpacing.sm),
                    LoadingShimmer(width: 120, height: 12),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          LoadingShimmer(height: 12),
          SizedBox(height: AppSpacing.sm),
          LoadingShimmer(width: 200, height: 12),
        ],
      ),
    );
  }
}

/// List shimmer for loading multiple items
class ListShimmer extends StatelessWidget {
  const ListShimmer({
    super.key,
    this.itemCount = 3,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.listItemGap),
          child: CardShimmer(),
        ),
      ),
    );
  }
}
