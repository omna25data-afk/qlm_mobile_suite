import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/features/guardian/presentation/viewmodels/guardian_viewmodel.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';
import 'package:qlm_mobile_suite/features/admin/presentation/screens/guardian_details_screen.dart';

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
    _tabController = TabController(length: 7, vsync: this);
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
        // Professional Sub-Tabs with modern styling
        Container(
          color: theme.scaffoldBackgroundColor,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: theme.colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 4,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            tabs: const [
              Tab(text: 'الأمناء', icon: Icon(Icons.people_outline_rounded, size: 24)),
              Tab(text: 'التراخيص', icon: Icon(Icons.receipt_long_outlined, size: 24)),
              Tab(text: 'البطائق', icon: Icon(Icons.credit_card_outlined, size: 24)),
              Tab(text: 'المناطق', icon: Icon(Icons.map_outlined, size: 24)),
              Tab(text: 'التكليفات', icon: Icon(Icons.assignment_ind_outlined, size: 24)),
              Tab(text: 'التفتيش', icon: Icon(Icons.fact_check_outlined, size: 24)),
              Tab(text: 'التقييم', icon: Icon(Icons.star_outline_rounded, size: 24)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGuardiansTab(),
              _buildPlaceholder('التراخيص'),
              _buildPlaceholder('البطائق'),
              _buildPlaceholder('المناطق'),
              _buildAssignmentsTab(),
              _buildPlaceholder('الفحص والتفتيش'),
              _buildPlaceholder('التقييم'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '$title - قيد التنفيذ',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final statusColor = isActive ? const Color(0xFF10B981) : Colors.redAccent;

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
                builder: (context) => GuardianDetailsScreen(guardian: guardian),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with Badge
                Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          guardian.fullName?.substring(0, 1) ?? 'أ',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guardian.fullName ?? 'أمين غير معروف',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guardian.specializationAreaName ?? 'غير محدد',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 14, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            guardian.phoneNumber ?? '---',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Trailing
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'نشط' : 'متوقف',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    final viewModel = context.watch<GuardianViewModel>();
    final theme = Theme.of(context);

    if (viewModel.isLoading && viewModel.assignments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.assignments.isEmpty) {
      return const Center(child: Text('لا توجد تكليفات نشطة حالياً'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: viewModel.assignments.length,
      itemBuilder: (context, index) {
        final assignment = viewModel.assignments[index];
        return _buildAssignmentCard(assignment, theme);
      },
    );
  }

  Widget _buildAssignmentCard(dynamic assignment, ThemeData theme) {
    final isTemp = assignment.assignmentType == 'temporary_delegation';
    final accentColor = isTemp ? const Color(0xFF3B82F6) : const Color(0xFF10B981);
    
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                Expanded(
                  child: Text(
                    assignment.assignedGuardianName ?? 'أمين غير معروف',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    assignment.typeText,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                   Icon(Icons.location_on_rounded, size: 20, color: accentColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'المكلف بها: ${assignment.geographicAreaName ?? '---'}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDateTag(Icons.calendar_today_rounded, 'من', assignment.startDate),
                const SizedBox(width: 8),
                if (assignment.endDate != null)
                  _buildDateTag(Icons.event_available_rounded, 'إلى', assignment.endDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTag(IconData icon, String label, DateTime? date) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text('$label: ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(
              date?.toString().substring(0, 10) ?? '---',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
