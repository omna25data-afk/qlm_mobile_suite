import 'package:qlm_mobile_suite/core/database/local_database_service.dart';
import 'package:qlm_mobile_suite/core/network/api_client.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/registry_entry_model.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/repositories/registry_repository.dart';
import 'package:sqflite/sqflite.dart';

class RegistryRepositoryImpl implements RegistryRepository {
  final LocalDatabaseService _dbService;
  final ApiClient _apiClient;

  RegistryRepositoryImpl(this._dbService, this._apiClient);

  @override
  Future<List<RegistryEntry>> getEntries({bool localOnly = false}) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('registry_entries', orderBy: 'updated_at DESC');

    return List.generate(maps.length, (i) {
      return RegistryEntryModel.fromJson(maps[i]);
    });
  }

  @override
  Future<RegistryEntry> getEntryById(String uuid) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'registry_entries',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (maps.isNotEmpty) {
      return RegistryEntryModel.fromJson(maps.first);
    } else {
      throw Exception('Entry not found');
    }
  }

  @override
  Future<void> saveEntry(RegistryEntry entry) async {
    final db = await _dbService.database;
    final model = entry is RegistryEntryModel ? entry : _toModel(entry);
    
    await db.insert(
      'registry_entries',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> syncEntries() async {
    try {
      // 1. Pull from Server
      final response = await _apiClient.dio.get('/sync/pull');
      final List<dynamic> remoteData = response.data['entries'] ?? [];

      final db = await _dbService.database;
      
      await db.transaction((txn) async {
        for (var data in remoteData) {
          final model = RegistryEntryModel.fromJson(data);
          await txn.insert(
            'registry_entries',
            model.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      
      // 2. Push Local Changes (Implement later)
      // TODO: Implement push local changes
    } catch (e) {
      throw Exception('Sync failed: $e');
    }
  }

  RegistryEntryModel _toModel(RegistryEntry entity) {
    return RegistryEntryModel(
      uuid: entity.uuid,
      serialNumber: entity.serialNumber,
      hijriYear: entity.hijriYear,
      constraintTypeId: entity.constraintTypeId,
      contractTypeId: entity.contractTypeId,
      subtype1: entity.subtype1,
      subtype2: entity.subtype2,
      firstPartyName: entity.firstPartyName,
      secondPartyName: entity.secondPartyName,
      writerType: entity.writerType,
      writerId: entity.writerId,
      otherWriterId: entity.otherWriterId,
      writerName: entity.writerName,
      documentHijriDate: entity.documentHijriDate,
      documentGregorianDate: entity.documentGregorianDate,
      docRecordBookId: entity.docRecordBookId,
      docRecordBookNumber: entity.docRecordBookNumber,
      docPageNumber: entity.docPageNumber,
      docEntryNumber: entity.docEntryNumber,
      docBoxNumber: entity.docBoxNumber,
      docDocumentNumber: entity.docDocumentNumber,
      docHijriDate: entity.docHijriDate,
      docGregorianDate: entity.docGregorianDate,
      feeAmount: entity.feeAmount,
      hasAuthenticationFee: entity.hasAuthenticationFee,
      authenticationFeeAmount: entity.authenticationFeeAmount,
      hasTransferFee: entity.hasTransferFee,
      transferFeeAmount: entity.transferFeeAmount,
      hasOtherFee: entity.hasOtherFee,
      otherFeeAmount: entity.otherFeeAmount,
      penaltyAmount: entity.penaltyAmount,
      supportAmount: entity.supportAmount,
      receiptNumber: entity.receiptNumber,
      sustainabilityAmount: entity.sustainabilityAmount,
      exemptionType: entity.exemptionType,
      exemptionReason: entity.exemptionReason,
      guardianId: entity.guardianId,
      guardianRecordBookId: entity.guardianRecordBookId,
      guardianRecordBookNumber: entity.guardianRecordBookNumber,
      guardianPageNumber: entity.guardianPageNumber,
      guardianEntryNumber: entity.guardianEntryNumber,
      guardianHijriDate: entity.guardianHijriDate,
      status: entity.status,
      deliveryStatus: entity.deliveryStatus,
      notes: entity.notes,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }
}
