/// Records Management Screen with 2 tabs (السجلات - القيود)
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/empty_state.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

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
                Tab(text: 'السجلات'),
                Tab(text: 'القيود'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _RecordBooksTab(),
                _EntriesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordBooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStates.noRecords(
      onAdd: () {
        // TODO: إضافة سجل جديد
      },
    );
  }
}

class _EntriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStates.noEntries(
      onAdd: () {
        // TODO: إضافة قيد جديد
      },
    );
  }
}
