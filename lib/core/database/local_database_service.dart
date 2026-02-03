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
            uuid TEXT PRIMARY KEY,
            serial_number INTEGER,
            hijri_year INTEGER,
            constraint_type_id INTEGER,
            contract_type_id INTEGER,
            subtype_1 INTEGER,
            subtype_2 INTEGER,
            first_party_name TEXT,
            second_party_name TEXT,
            writer_type TEXT,
            writer_id INTEGER,
            other_writer_id INTEGER,
            writer_name TEXT,
            document_hijri_date TEXT,
            document_gregorian_date TEXT,
            doc_record_book_id INTEGER,
            doc_record_book_number TEXT,
            doc_page_number INTEGER,
            doc_entry_number INTEGER,
            doc_box_number TEXT,
            doc_document_number TEXT,
            doc_hijri_date TEXT,
            doc_gregorian_date TEXT,
            fee_amount REAL,
            has_authentication_fee INTEGER,
            authentication_fee_amount REAL,
            has_transfer_fee INTEGER,
            transfer_fee_amount REAL,
            has_other_fee INTEGER,
            other_fee_amount REAL,
            penalty_amount REAL,
            support_amount REAL,
            receipt_number TEXT,
            sustainability_amount REAL,
            exemption_type TEXT,
            exemption_reason TEXT,
            guardian_id INTEGER,
            guardian_record_book_id INTEGER,
            guardian_record_book_number TEXT,
            guardian_page_number INTEGER,
            guardian_entry_number INTEGER,
            guardian_hijri_date TEXT,
            status TEXT,
            delivery_status TEXT,
            notes TEXT,
            created_by INTEGER,
            created_at TEXT,
            updated_at TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }
}
