import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/usecases/get_guardians_usecase.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/repositories/guardian_repository.dart';

class GuardianViewModel extends ChangeNotifier {
  final GetGuardiansUseCase _getGuardiansUseCase;
  final GuardianRepository _repository;

  GuardianViewModel(this._getGuardiansUseCase, this._repository);

  List<Guardian> _guardians = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Guardian> get guardians => _guardians;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadGuardians({bool localOnly = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guardians = await _getGuardiansUseCase.execute(localOnly: localOnly);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.syncGuardians();
      _guardians = await _getGuardiansUseCase.execute(localOnly: true);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
