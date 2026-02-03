import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/viewmodels/registry_viewmodel.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_details_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/registry_entry_model.dart';

class RegistryListScreen extends StatefulWidget {
  const RegistryListScreen({super.key});

  @override
  State<RegistryListScreen> createState() => _RegistryListScreenState();
}

class _RegistryListScreenState extends State<RegistryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RegistryViewModel>().loadEntries(localOnly: true));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistryViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل القيود المركزي'),
        actions: [
          IconButton(
            icon: viewModel.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.sync_rounded),
            onPressed: viewModel.isLoading ? null : () => viewModel.syncData(),
          ),
        ],
      ),
      body: _buildBody(viewModel, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Dummy Create for demonstration
          final newEntry = RegistryEntryModel(
            uuid: const Uuid().v4(),
            firstPartyName: 'قيد تجريبي جديد',
            secondPartyName: 'تجربة الإضافة',
            status: 'draft',
            createdAt: DateTime.now(),
            isSynced: false,
          );
          await context.read<RegistryViewModel>().saveEntry(newEntry);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إنشاء المسودة محلياً')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(RegistryViewModel viewModel, ThemeData theme) {
    if (viewModel.isLoading && viewModel.entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 10),
            Text(viewModel.errorMessage!),
            ElevatedButton(
              onPressed: () => viewModel.loadEntries(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (viewModel.entries.isEmpty) {
      return const Center(
        child: Text('لا يوجد قيود حالياً. قم بالمزامنة أو إضافة قيد جديد.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadEntries(),
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: viewModel.entries.length,
        itemBuilder: (context, index) {
          final entry = viewModel.entries[index];
          return _buildEntryCard(entry, theme);
        },
      ),
    );
  }

  Widget _buildEntryCard(RegistryEntry entry, ThemeData theme) {
    final statusColor = entry.status == 'documented' ? Colors.green : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.1),
          child: Icon(Icons.description_rounded, color: statusColor),
        ),
        title: Text(
          'قيد رقم: ${entry.serialNumber ?? '---'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('الأطراف: ${entry.firstPartyName ?? '---'} و ${entry.secondPartyName ?? '---'}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    entry.status == 'documented' ? 'موثق' : 'مسودة',
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ),
                if (!entry.isSynced) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.cloud_off_rounded, size: 16, color: Colors.grey),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (_) => RegistryDetailsScreen(entry: entry),
            ),
          );
        },
      ),
    );
  }
}
