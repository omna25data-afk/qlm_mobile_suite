/// Add Entry Screen - Form for creating new registry entry
import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_spacing.dart';
import 'package:qlm_mobile_suite/core/theme/app_colors.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/custom_text_field.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/custom_button.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstPartyController = TextEditingController();
  final _secondPartyController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedRecordBook;
  String? _selectedContractType;

  @override
  void dispose() {
    _firstPartyController.dispose();
    _secondPartyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إضافة قيد جديد',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Record Book dropdown
            _buildDropdown(
              label: 'السجل',
              hint: 'اختر السجل',
              value: _selectedRecordBook,
              items: ['سجل عقود الزواج - 2026', 'سجل عقود الطلاق - 2026'],
              onChanged: (v) => setState(() => _selectedRecordBook = v),
            ),
            const SizedBox(height: AppSpacing.md),

            // Contract Type dropdown
            _buildDropdown(
              label: 'نوع العقد',
              hint: 'اختر نوع العقد',
              value: _selectedContractType,
              items: ['عقد زواج', 'عقد طلاق', 'إثبات رجعة'],
              onChanged: (v) => setState(() => _selectedContractType = v),
            ),
            const SizedBox(height: AppSpacing.md),

            // First Party
            CustomTextField(
              controller: _firstPartyController,
              label: 'الطرف الأول',
              hint: 'اسم الطرف الأول',
              prefixIcon: Icons.person,
              validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Second Party
            CustomTextField(
              controller: _secondPartyController,
              label: 'الطرف الثاني',
              hint: 'اسم الطرف الثاني',
              prefixIcon: Icons.person_outline,
              validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Notes
            CustomTextField(
              controller: _notesController,
              label: 'ملاحظات',
              hint: 'ملاحظات إضافية (اختياري)',
              prefixIcon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'حفظ كمسودة',
                    variant: ButtonVariant.outlined,
                    onPressed: _saveDraft,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomButton(
                    label: 'إرسال',
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveDraft() {
    if (_formKey.currentState?.validate() == true) {
      // TODO: حفظ كمسودة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ كمسودة')),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true) {
      // TODO: إرسال
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الإرسال بنجاح')),
      );
    }
  }
}
