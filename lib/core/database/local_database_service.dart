import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class LocalDatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: (db, version) async {
        // Tables will be created here
        await db.execute('''
          CREATE TABLE registry_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT UNIQUE,
            serial_number INTEGER,
            first_party_name TEXT,
            second_party_name TEXT,
            contract_type_id INTEGER,
            status TEXT,
            transaction_date TEXT,
            synced INTEGER DEFAULT 0,
            form_data TEXT
          )
        ''');
      },
    );
  }
}
