import 'package:qlm_mobile_suite/core/database/local_database_service.dart';
import 'package:qlm_mobile_suite/core/network/api_client.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/registry_entry_model.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/marriage_contract_model.dart';
import 'package:qlm_mobile_suite/features/registry/data/models/sale_contract_model.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/registry_entry_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/record_book_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/marriage_contract_entity.dart';
import 'package:qlm_mobile_suite/features/registry/domain/entities/sale_contract_entity.dart';
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
  Future<void> saveEntry(
    RegistryEntry entry, {
    MarriageContract? marriageContract,
    SaleContract? saleContract,
  }) async {
    final db = await _dbService.database;
    final model = entry is RegistryEntryModel ? entry : _toModel(entry);
    
    await db.transaction((txn) async {
      // 1. Save Main Entry
      await txn.insert(
        'registry_entries',
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 2. Save Sub-Contract if available
      if (marriageContract != null) {
        final subModel = marriageContract is MarriageContractModel 
            ? marriageContract 
            : MarriageContractModel(
                uuid: marriageContract.uuid,
                registryEntryUuid: marriageContract.registryEntryUuid,
                husbandName: marriageContract.husbandName,
                groomNationalId: marriageContract.groomNationalId,
                husbandBirthDate: marriageContract.husbandBirthDate,
                groomAge: marriageContract.groomAge,
                wifeName: marriageContract.wifeName,
                brideNationalId: marriageContract.brideNationalId,
                wifeBirthDate: marriageContract.wifeBirthDate,
                wifeAge: marriageContract.wifeAge,
                brideAge: marriageContract.brideAge,
                guardianName: marriageContract.guardianName,
                guardianRelation: marriageContract.guardianRelation,
                dowryAmount: marriageContract.dowryAmount,
                dowryPaid: marriageContract.dowryPaid,
                witnesses: marriageContract.witnesses,
              );
        await txn.insert(
          'marriage_contracts',
          subModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      if (saleContract != null) {
        final subModel = saleContract is SaleContractModel 
            ? saleContract 
            : SaleContractModel(
                uuid: saleContract.uuid,
                registryEntryUuid: saleContract.registryEntryUuid,
                sellerName: saleContract.sellerName,
                sellerNationalId: saleContract.sellerNationalId,
                buyerName: saleContract.buyerName,
                buyerNationalId: saleContract.buyerNationalId,
                saleType: saleContract.saleType,
                saleSubtype: saleContract.saleSubtype,
                saleArea: saleContract.saleArea,
                saleAreaQasab: saleContract.saleAreaQasab,
                saleAreaSqm: saleContract.saleAreaSqm,
                salePrice: saleContract.salePrice,
                taxAmount: saleContract.taxAmount,
                taxReceiptNumber: saleContract.taxReceiptNumber,
                zakatAmount: saleContract.zakatAmount,
                zakatReceiptNumber: saleContract.zakatReceiptNumber,
                propertyType: saleContract.propertyType,
                propertyLocation: saleContract.propertyLocation,
                propertyBoundaries: saleContract.propertyBoundaries,
                deedNumber: saleContract.deedNumber,
                itemDescription: saleContract.itemDescription,
                paymentMethod: saleContract.paymentMethod,
                witnesses: saleContract.witnesses,
              );
        await txn.insert(
          'sale_contracts',
          subModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> syncEntries() async {
    try {
      // 1. Pull from Server
      final response = await _apiClient.dio.get('/sync/pull');
      final List<dynamic> remoteData = response.data['registry_entries'] ?? [];
      final List<dynamic> recordBooksData = response.data['record_books'] ?? [];

      final db = await _dbService.database;
      
      await db.transaction((txn) async {
        // Sync Registry Entries
        for (var data in remoteData) {
          final model = RegistryEntryModel.fromJson(data);
          await txn.insert(
            'registry_entries',
            model.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Sync Record Books
        for (var data in recordBooksData) {
          await txn.insert(
            'record_books',
            {
              'id': data['id'],
              'legitimate_guardian_id': data['legitimate_guardian_id'],
              'book_number': data['book_number'],
              'start_date': data['start_date'],
              'end_date': data['end_date'],
              'status': data['status'],
              'is_full': data['is_full'] == true ? 1 : 0,
              'created_at': data['created_at'],
              'updated_at': data['updated_at'],
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      
      // 2. Push Local Changes
      final List<Map<String, dynamic>> unSyncedMaps = await db.query(
        'registry_entries',
        where: 'is_synced = ?',
        whereArgs: [0],
      );

      if (unSyncedMaps.isNotEmpty) {
        List<Map<String, dynamic>> payload = [];
        for (var map in unSyncedMaps) {
          Map<String, dynamic> entryData = Map.from(map);
          final contractType = entryData['contract_type_id'];
          final uuid = entryData['uuid'];
          
          if (contractType == 1) { // Marriage
            final sub = await db.query('marriage_contracts', where: 'registry_entry_uuid = ?', whereArgs: [uuid]);
            if (sub.isNotEmpty) entryData['marriage_contract'] = sub.first;
          } else if (contractType == 2) { // Sale
            final sub = await db.query('sale_contracts', where: 'registry_entry_uuid = ?', whereArgs: [uuid]);
            if (sub.isNotEmpty) entryData['sale_contract'] = sub.first;
          }
          
          payload.add(entryData);
        }

        await _apiClient.dio.post('/sync/push', data: {'registry_entries': payload});
        
        await db.transaction((txn) async {
          for (var map in unSyncedMaps) {
            await txn.update(
              'registry_entries',
              {'is_synced': 1},
              where: 'uuid = ?',
              whereArgs: [map['uuid']],
            );
          }
        });
      }
    } catch (e) {
      throw Exception('Sync failed: $e');
    }
  }

  @override
  Future<List<RecordBook>> getRecordBooks() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('record_books', orderBy: 'id DESC');

    return List.generate(maps.length, (i) {
      return RecordBook(
        id: maps[i]['id'],
        legitimateGuardianId: maps[i]['legitimate_guardian_id'],
        bookNumber: maps[i]['book_number'],
        startDate: maps[i]['start_date'] != null ? DateTime.parse(maps[i]['start_date']) : null,
        endDate: maps[i]['end_date'] != null ? DateTime.parse(maps[i]['end_date']) : null,
        status: maps[i]['status'],
        isFull: maps[i]['is_full'] == 1,
        createdAt: maps[i]['created_at'] != null ? DateTime.parse(maps[i]['created_at']) : null,
        updatedAt: maps[i]['updated_at'] != null ? DateTime.parse(maps[i]['updated_at']) : null,
      );
    });
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
