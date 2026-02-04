/// My Records Screen - Guardian's personal records and entries
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/empty_state.dart';

class MyRecordsScreen extends StatelessWidget {
  const MyRecordsScreen({super.key});

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
                Tab(text: 'دفاتري'),
                Tab(text: 'قيودي'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _MyBooksTab(),
                _MyEntriesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyBooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStates.noRecords();
  }
}

class _MyEntriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStates.noEntries();
  }
}
