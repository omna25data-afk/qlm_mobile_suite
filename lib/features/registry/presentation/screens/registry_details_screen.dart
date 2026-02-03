import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:intl/intl.dart';

class RegistryDetailsScreen extends StatelessWidget {
  final RegistryEntry entry;

  const RegistryDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'ر.ي', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل القيد: ${entry.serialNumber ?? '---'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              // TODO: Navigate to Edit
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusBanner(theme),
          const SizedBox(height: 20),
          
          _buildSectionTitle(theme, 'البيانات الأساسية'),
          _buildInfoTile('الرقم التسلسلي', entry.serialNumber?.toString() ?? '---'),
          _buildInfoTile('السنة الهجرية', entry.hijriYear?.toString() ?? '---'),
          _buildInfoTile('الطرف الأول', entry.firstPartyName ?? '---'),
          _buildInfoTile('الطرف الثاني', entry.secondPartyName ?? '---'),
          _buildInfoTile('نوع المحرر', entry.writerType ?? '---'),
          _buildInfoTile('اسم الكاتب', entry.writerName ?? '---'),
          
          const Divider(height: 40),
          _buildSectionTitle(theme, 'بيانات الرسوم'),
          _buildInfoTile('مبلغ الرسم', currencyFormat.format(entry.feeAmount ?? 0)),
          _buildInfoTile('رسم التوثيق', currencyFormat.format(entry.authenticationFeeAmount ?? 0)),
          _buildInfoTile('رسم التحويل', currencyFormat.format(entry.transferFeeAmount ?? 0)),
          _buildInfoTile('رقم الإيصال', entry.receiptNumber ?? '---'),
          if (entry.exemptionType != null) ...[
            _buildInfoTile('نوع الإعفاء', entry.exemptionType!),
            _buildInfoTile('سبب الإعفاء', entry.exemptionReason ?? '---'),
          ],
          
          const Divider(height: 40),
          _buildSectionTitle(theme, 'بيانات التوثيق (قلم العرض)'),
          _buildInfoTile('رقم السجل', entry.docRecordBookNumber ?? '---'),
          _buildInfoTile('رقم الصفحة', entry.docPageNumber?.toString() ?? '---'),
          _buildInfoTile('رقم القيد', entry.docEntryNumber?.toString() ?? '---'),
          _buildInfoTile('رقم الوثيقة', entry.docDocumentNumber ?? '---'),
          
          const SizedBox(height: 30),
          if (entry.notes != null && entry.notes!.isNotEmpty) ...[
            _buildSectionTitle(theme, 'ملاحظات'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(entry.notes!, style: theme.textTheme.bodyMedium),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBanner(ThemeData theme) {
    final statusColor = entry.status == 'documented' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            entry.status == 'documented' ? Icons.check_circle_rounded : Icons.info_rounded,
            color: statusColor,
          ),
          const SizedBox(width: 12),
          Text(
            entry.status == 'documented' ? 'هذا القيد معتمد وموثق' : 'هذا القيد في مرحلة المسودة',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
