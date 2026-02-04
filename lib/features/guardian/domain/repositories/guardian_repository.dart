import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';

abstract class GuardianRepository {
  Future<List<Guardian>> getGuardians({bool localOnly = false});
  Future<Guardian> getGuardianById(String uuid);
  Future<void> syncGuardians();
}
