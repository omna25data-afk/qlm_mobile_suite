import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/usecases/get_guardians_usecase.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/repositories/guardian_repository.dart';

import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_assignment_entity.dart';

class GuardianViewModel extends ChangeNotifier {
  final GetGuardiansUseCase _getGuardiansUseCase;
  final GuardianRepository _repository;

  GuardianViewModel(this._getGuardiansUseCase, this._repository);

  List<Guardian> _guardians = [];
  List<GuardianAssignment> _assignments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Guardian> get guardians => _guardians;
  List<GuardianAssignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadGuardians({bool localOnly = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guardians = await _getGuardiansUseCase.execute(localOnly: localOnly);
      // Load sample assignments for now
      _loadSampleAssignments();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadSampleAssignments() {
    _assignments = [
      GuardianAssignment(
        id: 1,
        assignedGuardianName: 'أحمد علي محمد',
        geographicAreaName: 'عزلة الربع الشرقي',
        assignmentType: 'temporary_delegation',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 20)),
        isActive: true,
      ),
      GuardianAssignment(
        id: 2,
        assignedGuardianName: 'صالح حسن يحيى',
        geographicAreaName: 'عزلة المطار',
        assignmentType: 'permanent_transfer',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        isActive: true,
      ),
    ];
  }

  Future<void> syncData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.syncGuardians();
      _guardians = await _getGuardiansUseCase.execute(localOnly: true);
      _loadSampleAssignments();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
