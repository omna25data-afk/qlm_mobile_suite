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

        await db.execute('''
          CREATE TABLE marriage_contracts (
            uuid TEXT PRIMARY KEY,
            registry_entry_uuid TEXT,
            husband_name TEXT,
            groom_national_id TEXT,
            husband_birth_date TEXT,
            groom_age INTEGER,
            wife_name TEXT,
            bride_national_id TEXT,
            wife_birth_date TEXT,
            wife_age INTEGER,
            bride_age INTEGER,
            guardian_name TEXT,
            guardian_relation TEXT,
            dowry_amount REAL,
            dowry_paid REAL,
            witnesses TEXT,
            FOREIGN KEY (registry_entry_uuid) REFERENCES registry_entries (uuid) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE sale_contracts (
            uuid TEXT PRIMARY KEY,
            registry_entry_uuid TEXT,
            seller_name TEXT,
            seller_national_id TEXT,
            buyer_name TEXT,
            buyer_national_id TEXT,
            sale_type TEXT,
            sale_subtype TEXT,
            sale_area REAL,
            sale_area_qasab TEXT,
            sale_area_sqm REAL,
            sale_price REAL,
            tax_amount REAL,
            tax_receipt_number TEXT,
            zakat_amount REAL,
            zakat_receipt_number TEXT,
            property_type TEXT,
            property_location TEXT,
            property_boundaries TEXT,
            deed_number TEXT,
            item_description TEXT,
            payment_method TEXT,
            witnesses TEXT,
            FOREIGN KEY (registry_entry_uuid) REFERENCES registry_entries (uuid) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE guardians (
            uuid TEXT PRIMARY KEY,
            first_name TEXT,
            father_name TEXT,
            family_name TEXT,
            full_name TEXT,
            phone_number TEXT,
            home_phone TEXT,
            birth_date TEXT,
            birth_place TEXT,
            proof_type TEXT,
            proof_number TEXT,
            issuing_authority TEXT,
            issue_date TEXT,
            expiry_date TEXT,
            qualification TEXT,
            job TEXT,
            workplace TEXT,
            specialization_area_id INTEGER,
            specialization_area_name TEXT,
            weapon_license_number TEXT,
            weapon_license_type TEXT,
            weapon_license_expiry TEXT,
            electronic_card_number TEXT,
            electronic_card_issue_date TEXT,
            electronic_card_expiry_date TEXT,
            employment_status TEXT,
            stop_date TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
      },
    );
  }
}
