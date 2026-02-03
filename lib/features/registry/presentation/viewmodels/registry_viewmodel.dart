import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/usecases/get_registry_entries_usecase.dart';
import 'package:qlm_mobile_suite/features/registry/domain/repositories/registry_repository.dart';

class RegistryViewModel extends ChangeNotifier {
  final GetRegistryEntriesUseCase _getEntriesUseCase;
  final RegistryRepository _repository; // Temporary reference for sync

  RegistryViewModel(this._getEntriesUseCase, this._repository);

  List<RegistryEntry> _entries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RegistryEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadEntries({bool localOnly = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _entries = await _getEntriesUseCase.execute(localOnly: localOnly);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.syncEntries();
      await loadEntries(localOnly: true);
    } catch (e) {
      _errorMessage = 'Sync failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveEntry(RegistryEntry entry) async {
    await _repository.saveEntry(entry);
    await loadEntries(localOnly: true);
  }
}
