import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/viewmodels/registry_viewmodel.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_details_screen.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/screens/registry_form_screen.dart';

class RegistryListScreen extends StatefulWidget {
  const RegistryListScreen({super.key});

  @override
  State<RegistryListScreen> createState() => _RegistryListScreenState();
}

class _RegistryListScreenState extends State<RegistryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RegistryViewModel>().loadEntries(localOnly: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistryViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سجل القيود المركزي',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: viewModel.isLoading 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync_rounded, size: 20),
              onPressed: viewModel.isLoading ? null : () => viewModel.syncData(),
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: _buildBody(viewModel, theme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistryFormScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة قيد جديد', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBody(RegistryViewModel viewModel, ThemeData theme) {
    if (viewModel.isLoading && viewModel.entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.loadEntries(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 24),
            Text(
              'لا يوجد قيود حالياً',
              style: TextStyle(fontSize: 18, color: Colors.grey[400], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بالمزامنة أو إضافة قيد جديد للبدء',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadEntries(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: viewModel.entries.length,
        itemBuilder: (context, index) {
          final entry = viewModel.entries[index];
          return _buildEntryCard(entry, theme);
        },
      ),
    );
  }

  Widget _buildEntryCard(RegistryEntry entry, ThemeData theme) {
    final isDocumented = entry.status == 'documented';
    final statusColor = isDocumented ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => RegistryDetailsScreen(entry: entry),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'رقم القيد: ${entry.serialNumber ?? '---'}',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (!entry.isSynced) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.cloud_upload_outlined, size: 16, color: Colors.grey[400]),
                        ],
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDocumented ? 'موثق' : 'مسودة',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'الأطراف المتعاقدة:',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                   children: [
                    Expanded(
                      child: Text(
                        entry.firstPartyName ?? '---',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Icon(Icons.swap_horiz_rounded, size: 16, color: Colors.grey[300]),
                    Expanded(
                      child: Text(
                        entry.secondPartyName ?? '---',
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history_edu_rounded, size: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'التفاصيل الكاملة',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
