import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/record_book_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/marriage_contract_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/sale_contract_entity.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/viewmodels/registry_viewmodel.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/registry_entry_model.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/custom_text_field.dart';
import 'package:qlm_mobile_suite/core/presentation/widgets/custom_button.dart';
import 'package:uuid/uuid.dart';

class RegistryFormScreen extends StatefulWidget {
  final RegistryEntry? entry;

  const RegistryFormScreen({super.key, this.entry});

  @override
  State<RegistryFormScreen> createState() => _RegistryFormScreenState();
}

class _RegistryFormScreenState extends State<RegistryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Core Controllers
  late TextEditingController _serialController;
  late TextEditingController _firstPartyController;
  late TextEditingController _secondPartyController;
  late TextEditingController _notesController;
  late TextEditingController _feeController;
  late TextEditingController _pageNumberController;
  late TextEditingController _entryNumberController;

  // Marriage Controllers
  late TextEditingController _husbandIdController;
  late TextEditingController _wifeIdController;
  late TextEditingController _dowryController;

  // Sale Controllers
  late TextEditingController _sellerIdController;
  late TextEditingController _buyerIdController;
  late TextEditingController _salePriceController;

  // Selection States
  int? _selectedRecordBookId;
  int _selectedContractTypeId = 1; // 1: Marriage, 2: Sale, etc.
  String _status = 'draft';

  @override
  void initState() {
    super.initState();
    // Core
    _serialController = TextEditingController(text: widget.entry?.serialNumber?.toString() ?? '');
    _firstPartyController = TextEditingController(text: widget.entry?.firstPartyName ?? '');
    _secondPartyController = TextEditingController(text: widget.entry?.secondPartyName ?? '');
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
    _feeController = TextEditingController(text: widget.entry?.feeAmount?.toString() ?? '');
    _pageNumberController = TextEditingController(text: widget.entry?.guardianPageNumber?.toString() ?? '');
    _entryNumberController = TextEditingController(text: widget.entry?.guardianEntryNumber?.toString() ?? '');
    
    // Marriage
    _husbandIdController = TextEditingController();
    _wifeIdController = TextEditingController();
    _dowryController = TextEditingController();

    // Sale
    _sellerIdController = TextEditingController();
    _buyerIdController = TextEditingController();
    _salePriceController = TextEditingController();

    _status = widget.entry?.status ?? 'draft';
    _selectedRecordBookId = widget.entry?.guardianRecordBookId;
    _selectedContractTypeId = widget.entry?.contractTypeId ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistryViewModel>().loadRecordBooks();
    });
  }

  @override
  void dispose() {
    _serialController.dispose();
    _firstPartyController.dispose();
    _secondPartyController.dispose();
    _notesController.dispose();
    _feeController.dispose();
    _pageNumberController.dispose();
    _entryNumberController.dispose();
    _husbandIdController.dispose();
    _wifeIdController.dispose();
    _dowryController.dispose();
    _sellerIdController.dispose();
    _buyerIdController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<RegistryViewModel>();
      final entryUuid = widget.entry?.uuid ?? const Uuid().v4();
      
      final entry = RegistryEntryModel(
        uuid: entryUuid,
        serialNumber: int.tryParse(_serialController.text),
        firstPartyName: _firstPartyController.text,
        secondPartyName: _secondPartyController.text,
        notes: _notesController.text,
        feeAmount: double.tryParse(_feeController.text),
        status: _status,
        guardianRecordBookId: _selectedRecordBookId,
        guardianPageNumber: int.tryParse(_pageNumberController.text),
        guardianEntryNumber: int.tryParse(_entryNumberController.text),
        contractTypeId: _selectedContractTypeId,
        isSynced: false,
        updatedAt: DateTime.now(),
        createdAt: widget.entry?.createdAt ?? DateTime.now(),
      );

      MarriageContract? marriage;
      if (_selectedContractTypeId == 1) {
        marriage = MarriageContract(
          uuid: const Uuid().v4(),
          registryEntryUuid: entryUuid,
          husbandName: _firstPartyController.text,
          wifeName: _secondPartyController.text,
          groomNationalId: _husbandIdController.text,
          brideNationalId: _wifeIdController.text,
          dowryAmount: double.tryParse(_dowryController.text),
        );
      }

      SaleContract? sale;
      if (_selectedContractTypeId == 2) {
        sale = SaleContract(
          uuid: const Uuid().v4(),
          registryEntryUuid: entryUuid,
          sellerName: _firstPartyController.text,
          buyerName: _secondPartyController.text,
          sellerNationalId: _sellerIdController.text,
          buyerNationalId: _buyerIdController.text,
          salePrice: double.tryParse(_salePriceController.text),
        );
      }

      await viewModel.saveEntry(entry, marriageContract: marriage, saleContract: sale);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ البيانات محلياً')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistryViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entry == null ? 'إضافة قيد جديد' : 'تعديل القيد',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            onPressed: _save,
            tooltip: 'حفظ',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            _buildSection(
              title: 'بيانات السجل الورقي',
              icon: Icons.menu_book_rounded,
              children: [
                _buildRecordBookDropdown(viewModel),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _pageNumberController,
                        label: 'رقم الصفحة',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _entryNumberController,
                        label: 'رقم القيد في الصفحة',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            _buildSection(
              title: 'البيانات الأساسية للقيد',
              icon: Icons.description_rounded,
              children: [
                _buildContractTypeDropdown(),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _serialController,
                  label: 'رقم القيد التسلسلي العام',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _firstPartyController,
                  label: _getPartyLabel(1),
                  hint: 'الاسم الكامل كما هو في الهوية',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _secondPartyController,
                  label: _getPartyLabel(2),
                  hint: 'الاسم الكامل كما هو في الهوية',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
              ],
            ),

            if (_selectedContractTypeId == 1 || _selectedContractTypeId == 2) ...[
              const SizedBox(height: 24),
              _buildSection(
                title: 'بيانات العقد المخصصة',
                icon: Icons.fact_check_rounded,
                children: [
                  if (_selectedContractTypeId == 1) _buildMarriageFields(),
                  if (_selectedContractTypeId == 2) _buildSaleFields(),
                ],
              ),
            ],

            const SizedBox(height: 24),
            _buildSection(
              title: 'الرسوم والحالة',
              icon: Icons.payments_rounded,
              children: [
                CustomTextField(
                  controller: _feeController,
                  label: 'إجمالي الرسوم (ر.ي)',
                  prefixIcon: Icons.money_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildStatusDropdown(),
              ],
            ),

            const SizedBox(height: 24),
            _buildSection(
              title: 'ملاحظات وتفاصيل إضافية',
              icon: Icons.edit_note_rounded,
              children: [
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'ملاحظات الكاتب',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            CustomButton(
              text: 'حفظ القيد في السجل المحلي',
              onPressed: _save,
              icon: Icons.save_rounded,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMarriageFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _husbandIdController,
          label: 'رقم هوية الزوج',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _wifeIdController,
          label: 'رقم هوية الزوجة',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _dowryController,
          label: 'مبلغ المهر المسمى',
          prefixIcon: Icons.favorite_outline_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSaleFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _sellerIdController,
          label: 'رقم هوية البائع',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _buyerIdController,
          label: 'رقم هوية المشتري',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _salePriceController,
          label: 'ثمن البيع المتفق عليه',
          prefixIcon: Icons.sell_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildRecordBookDropdown(RegistryViewModel viewModel) {
    return DropdownButtonFormField<int>(
      value: _selectedRecordBookId,
      decoration: InputDecoration(
        labelText: 'اختار سجل السندات',
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      items: viewModel.recordBooks.map((book) {
        return DropdownMenuItem(
          value: book.id,
          child: Text('سجل رقم: ${book.bookNumber ?? book.id.toString()}'),
        );
      }).toList(),
      onChanged: (v) => setState(() => _selectedRecordBookId = v),
    );
  }

  Widget _buildContractTypeDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedContractTypeId,
      decoration: InputDecoration(
        labelText: 'نوع العقد / التصرف',
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      items: const [
        DropdownMenuItem(value: 1, child: Text('عقد زواج')),
        DropdownMenuItem(value: 2, child: Text('عقد بيع')),
        DropdownMenuItem(value: 3, child: Text('عقد وكالة')),
        DropdownMenuItem(value: 4, child: Text('إقرار تنازل')),
      ],
      onChanged: (v) => setState(() => _selectedContractTypeId = v!),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: InputDecoration(
        labelText: 'حالة القيد الحالية',
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      items: const [
        DropdownMenuItem(value: 'draft', child: Text('مسودة (قيد التحرير)')),
        DropdownMenuItem(value: 'documented', child: Text('موثق (تم تسليمه)')),
        DropdownMenuItem(value: 'archived', child: Text('مؤرشف')),
      ],
      onChanged: (v) => setState(() => _status = v!),
    );
  }

  String _getPartyLabel(int partNum) {
    if (_selectedContractTypeId == 1) return partNum == 1 ? 'اسم الزوج' : 'اسم الزوجة';
    if (_selectedContractTypeId == 2) return partNum == 1 ? 'اسم البائع' : 'اسم المشتري';
    if (_selectedContractTypeId == 3) return partNum == 1 ? 'اسم الموكل' : 'اسم الوكيل';
    return partNum == 1 ? 'الطرف الأول' : 'الطرف الثاني';
  }
}
