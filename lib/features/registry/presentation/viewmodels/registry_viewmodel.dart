import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/record_book_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/marriage_contract_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/sale_contract_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/usecases/get_registry_entries_usecase.dart';
import 'package:qlm_mobile_suite/features/registry/domain/repositories/registry_repository.dart';

class RegistryViewModel extends ChangeNotifier {
  final GetRegistryEntriesUseCase _getEntriesUseCase;
  final RegistryRepository _repository;

  RegistryViewModel(this._getEntriesUseCase, this._repository);

  List<RegistryEntry> _entries = [];
  List<RecordBook> _recordBooks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RegistryEntry> get entries => _entries;
  List<RecordBook> get recordBooks => _recordBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRecordBooks() async {
    try {
      _recordBooks = await _repository.getRecordBooks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load record books: $e';
      notifyListeners();
    }
  }

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
      await loadRecordBooks();
    } catch (e) {
      _errorMessage = 'Sync failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveEntry(
    RegistryEntry entry, {
    MarriageContract? marriageContract,
    SaleContract? saleContract,
  }) async {
    await _repository.saveEntry(
      entry,
      marriageContract: marriageContract,
      saleContract: saleContract,
    );
    await loadEntries(localOnly: true);
  }
}
