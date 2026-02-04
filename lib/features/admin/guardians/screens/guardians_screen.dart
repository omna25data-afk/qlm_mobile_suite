/// Guardians Management Screen with 6 tabs
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/empty_state.dart';

class GuardiansScreen extends StatelessWidget {
  const GuardiansScreen({super.key});

  static const List<Tab> _tabs = [
    Tab(text: 'الأمناء'),
    Tab(text: 'التراخيص'),
    Tab(text: 'البطاقات'),
    Tab(text: 'التجديدات'),
    Tab(text: 'المناطق'),
    Tab(text: 'الأرشيف'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        children: [
          // Top tabs
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              tabs: _tabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _GuardiansListTab(),
                _LicensesTab(),
                _CardsTab(),
                _RenewalsTab(),
                _AreasTab(),
                _ArchiveTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardiansListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStates.noRecords(
      onAdd: () {
        // TODO: إضافة أمين جديد
      },
    );
  }
}

class _LicensesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('التراخيص'));
  }
}

class _CardsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('البطاقات المهنية'));
  }
}

class _RenewalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('التجديدات'));
  }
}

class _AreasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('المناطق الجغرافية'));
  }
}

class _ArchiveTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الأرشيف'));
  }
}
