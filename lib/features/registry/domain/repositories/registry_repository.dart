import '../domain/entities/registry_entry_entity.dart';

abstract class RegistryRepository {
  Future<List<RegistryEntry>> getEntries({bool localOnly = false});
  Future<RegistryEntry> getEntryById(String uuid);
  Future<void> saveEntry(RegistryEntry entry);
  Future<void> syncEntries();
}
