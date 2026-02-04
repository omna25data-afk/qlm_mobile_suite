/// Reports Screen with 2 tabs (الإحصائيات - التقارير)
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'الإحصائيات'),
                Tab(text: 'التقارير'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _StatisticsTab(),
                _ReportsListTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Center(child: Text('الإحصائيات والرسوم البيانية')),
    );
  }
}

class _ReportsListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Center(child: Text('قائمة التقارير')),
    );
  }
}
