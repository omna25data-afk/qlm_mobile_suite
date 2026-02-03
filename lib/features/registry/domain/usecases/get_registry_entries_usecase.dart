import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/repositories/registry_repository.dart';

class GetRegistryEntriesUseCase {
  final RegistryRepository _repository;

  GetRegistryEntriesUseCase(this._repository);

  Future<List<RegistryEntry>> execute({bool localOnly = false}) {
    return _repository.getEntries(localOnly: localOnly);
  }
}
