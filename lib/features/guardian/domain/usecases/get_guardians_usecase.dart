import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/repositories/guardian_repository.dart';

class GetGuardiansUseCase {
  final GuardianRepository _repository;

  GetGuardiansUseCase(this._repository);

  Future<List<Guardian>> execute({bool localOnly = false}) {
    return _repository.getGuardians(localOnly: localOnly);
  }
}
