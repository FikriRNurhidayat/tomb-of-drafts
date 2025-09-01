import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static final DB _instance = DB._internal();
  static Database? _db;
  factory DB() => _instance;

  DB._internal();

  Future<Database> get connection async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS accounts (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            kind TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS categories (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS entries (
            id TEXT PRIMARY KEY,
            note TEXT NOT NULL,
            amount REAL NOT NULL,
            timestamp TEXT NOT NULL,
            status TEXT NOT NULL,
            category_id TEXT NOT NULL REFERENCES categories (id),
            account_id TEXT NOT NULL REFERENCES accounts (id),
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bandaio.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
}
