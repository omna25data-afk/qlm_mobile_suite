import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/record_book_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/marriage_contract_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/sale_contract_entity.dart';

abstract class RegistryRepository {
  Future<List<RegistryEntry>> getEntries({bool localOnly = false});
  Future<RegistryEntry> getEntryById(String uuid);
  Future<void> saveEntry(
    RegistryEntry entry, {
    MarriageContract? marriageContract,
    SaleContract? saleContract,
  });
  Future<void> syncEntries();
  Future<List<RecordBook>> getRecordBooks();
}
