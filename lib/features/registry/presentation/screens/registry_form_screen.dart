import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/viewmodels/registry_viewmodel.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/registry_entry_model.dart';
import 'package:uuid/uuid.dart';

class RegistryFormScreen extends StatefulWidget {
  final RegistryEntry? entry;

  const RegistryFormScreen({super.key, this.entry});

  @override
  State<RegistryFormScreen> createState() => _RegistryFormScreenState();
}

class _RegistryFormScreenState extends State<RegistryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for 50+ fields (Simplified for now with key fields)
  late TextEditingController _serialController;
  late TextEditingController _firstPartyController;
  late TextEditingController _secondPartyController;
  late TextEditingController _notesController;
  late TextEditingController _feeController;
  
  String _status = 'draft';

  @override
  void initState() {
    super.initState();
    _serialController = TextEditingController(text: widget.entry?.serialNumber?.toString() ?? '');
    _firstPartyController = TextEditingController(text: widget.entry?.firstPartyName ?? '');
    _secondPartyController = TextEditingController(text: widget.entry?.secondPartyName ?? '');
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
    _feeController = TextEditingController(text: widget.entry?.feeAmount?.toString() ?? '');
    _status = widget.entry?.status ?? 'draft';
  }

  @override
  void dispose() {
    _serialController.dispose();
    _firstPartyController.dispose();
    _secondPartyController.dispose();
    _notesController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<RegistryViewModel>();
      
      final entry = RegistryEntryModel(
        uuid: widget.entry?.uuid ?? const Uuid().v4(),
        serialNumber: int.tryParse(_serialController.text),
        firstPartyName: _firstPartyController.text,
        secondPartyName: _secondPartyController.text,
        notes: _notesController.text,
        feeAmount: double.tryParse(_feeController.text),
        status: _status,
        isSynced: false,
        updatedAt: DateTime.now(),
        createdAt: widget.entry?.createdAt ?? DateTime.now(),
      );

      await viewModel.saveEntry(entry);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'قيد جديد' : 'تعديل القيد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('البيانات الأساسية'),
            TextFormField(
              controller: _serialController,
              decoration: const InputDecoration(labelText: 'رقم القيد التسلسلي', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstPartyController,
              decoration: const InputDecoration(labelText: 'اسم الطرف الأول', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _secondPartyController,
              decoration: const InputDecoration(labelText: 'اسم الطرف الثاني', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('بيانات الحالة والمبالغ'),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'حالة القيد', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'draft', child: Text('مسودة')),
                DropdownMenuItem(value: 'documented', child: Text('موثق')),
                DropdownMenuItem(value: 'archived', child: Text('مؤرشف')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _feeController,
              decoration: const InputDecoration(labelText: 'إجمالي الرسوم (ر.ي)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('ملاحظات إضافية'),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'ملاحظات الكاتب', border: OutlineInputBorder()),
            ),
            
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
              label: const Text('حفظ التغييرات'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
