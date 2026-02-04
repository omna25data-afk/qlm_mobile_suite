import 'package:qlm_mobile_suite/features/guardian/domain/entities/guardian_entity.dart';
import 'package:qlm_mobile_suite/features/guardian/domain/repositories/guardian_repository.dart';
import 'package:qlm_mobile_suite/features/guardian/data/models/guardian_model.dart';
import 'package:qlm_mobile_suite/core/database/local_database_service.dart';
import 'package:qlm_mobile_suite/core/network/api_client.dart';
import 'package:sqflite/sqflite.dart';

class GuardianRepositoryImpl implements GuardianRepository {
  final LocalDatabaseService _dbService;
  final ApiClient _apiClient;

  GuardianRepositoryImpl(this._dbService, this._apiClient);

  @override
  Future<List<Guardian>> getGuardians({bool localOnly = false}) async {
    final db = await _dbService.database;
    
    if (!localOnly) {
      try {
        await syncGuardians();
      } catch (e) {
        // Log error and continue with local data
      }
    }

    final List<Map<String, dynamic>> maps = await db.query('guardians', orderBy: 'full_name ASC');
    return List.generate(maps.length, (i) => GuardianModel.fromJson(maps[i]));
  }

  @override
  Future<Guardian> getGuardianById(String uuid) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'guardians',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (maps.isNotEmpty) {
      return GuardianModel.fromJson(maps.first);
    }
    throw Exception('Guardian not found locally');
  }

  @override
  Future<void> syncGuardians() async {
    try {
      final response = await _apiClient.dio.get('/guardians/sync');
      final List<dynamic> remoteData = response.data['guardians'];
      
      final db = await _dbService.database;
      await db.transaction((txn) async {
        for (var data in remoteData) {
          final model = GuardianModel.fromJson(data);
          await txn.insert(
            'guardians',
            model.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      throw Exception('Failed to sync guardians: $e');
    }
  }
}
