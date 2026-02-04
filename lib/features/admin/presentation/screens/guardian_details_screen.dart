import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';

class GuardianDetailsScreen extends StatelessWidget {
  final Guardian guardian;

  const GuardianDetailsScreen({super.key, required this.guardian});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = guardian.employmentStatus == 'على رأس العمل';

    return Scaffold(
      appBar: AppBar(
        title: Text(guardian.fullName ?? 'تفاصيل الأمين'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            _buildHeader(theme, isActive),
            const SizedBox(height: 24),
            
            // Personal Info
            _buildSectionTitle('البيانات الشخصية والمهنية'),
            _buildInfoCard([
              _buildInfoRow(Icons.badge_rounded, 'رقم الإثبات', guardian.proofNumber ?? '---'),
              _buildInfoRow(Icons.phone_rounded, 'رقم التواصل', guardian.phoneNumber ?? '---'),
              _buildInfoRow(Icons.location_on_rounded, 'منطقة الاختصاص', guardian.specializationAreaName ?? '---'),
              _buildInfoRow(Icons.cake_rounded, 'تاريخ الميلاد', guardian.birthDate?.toString().substring(0, 10) ?? '---'),
              _buildInfoRow(Icons.school_rounded, 'المؤهل العلمي', guardian.qualification ?? '---'),
            ]),
            
            const SizedBox(height: 20),
            
            // License & Card Info
            _buildSectionTitle('حالة التراخيص والبطائق'),
            _buildInfoCard([
              _buildInfoRow(Icons.assignment_outlined, 'تاريخ انتهاء الترخيص', guardian.expiryDate?.toString().substring(0, 10) ?? '---'),
              _buildInfoRow(Icons.credit_card_outlined, 'تاريخ انتهاء البطاقة', guardian.electronicCardExpiryDate?.toString().substring(0, 10) ?? '---'),
            ]),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Actions implemented in future phases
                },
                icon: const Icon(Icons.edit_rounded),
                label: const Text('تعديل بيانات الأمين'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isActive) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              guardian.fullName?.substring(0, 1) ?? 'أ',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            guardian.fullName ?? 'أمين غير معروف',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (isActive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              guardian.employmentStatus ?? 'غير محدد',
              style: TextStyle(color: isActive ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
