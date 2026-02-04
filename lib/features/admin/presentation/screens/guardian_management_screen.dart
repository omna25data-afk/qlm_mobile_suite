import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/features/guardian/presentation/viewmodels/guardian_viewmodel.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';

class GuardianManagementScreen extends StatefulWidget {
  const GuardianManagementScreen({super.key});

  @override
  State<GuardianManagementScreen> createState() => _GuardianManagementScreenState();
}

class _GuardianManagementScreenState extends State<GuardianManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuardianViewModel>().loadGuardians();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Professional Sub-Tabs
        Container(
          color: theme.scaffoldBackgroundColor,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'الأمناء', icon: Icon(Icons.people_outline_rounded, size: 20)),
              Tab(text: 'التكليفات', icon: Icon(Icons.assignment_ind_outlined, size: 20)),
              Tab(text: 'التراخيص والبطاقات', icon: Icon(Icons.badge_outlined, size: 20)),
              Tab(text: 'مناطق الاختصاص', icon: Icon(Icons.map_outlined, size: 20)),
              Tab(text: 'التفتيش والرقابة', icon: Icon(Icons.fact_check_outlined, size: 20)),
            ],
          ),
        ),
        const Divider(height: 1),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGuardiansTab(),
              const Center(child: Text('التكليفات - قيد التنفيذ')),
              const Center(child: Text('التراخيص والبطاقات - قيد التنفيذ')),
              const Center(child: Text('مناطق الاختصاص - قيد التنفيذ')),
              const Center(child: Text('التفتيش والرقابة - قيد التنفيذ')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuardiansTab() {
    final viewModel = context.watch<GuardianViewModel>();
    final theme = Theme.of(context);

    if (viewModel.isLoading && viewModel.guardians.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.guardians.isEmpty) {
      return _buildError(viewModel);
    }

    if (viewModel.guardians.isEmpty) {
      return const Center(child: Text('لا يوجد أمناء مسجلون حالياً'));
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.syncData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: viewModel.guardians.length,
        itemBuilder: (context, index) {
          final guardian = viewModel.guardians[index];
          return _buildGuardianCard(guardian, theme);
        },
      ),
    );
  }

  Widget _buildGuardianCard(Guardian guardian, ThemeData theme) {
    final isActive = guardian.employmentStatus == 'على رأس العمل';
    final statusColor = isActive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            guardian.fullName?.substring(0, 1) ?? 'أ',
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          guardian.fullName ?? 'أمين غير معروف',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(guardian.phoneNumber ?? '---'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(guardian.specializationAreaName ?? 'غير محدد'),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isActive ? 'نشط' : 'متوقف',
                style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
        onTap: () {
          // TODO: Guardian Details
        },
      ),
    );
  }

  Widget _buildError(GuardianViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(viewModel.errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => viewModel.loadGuardians(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
