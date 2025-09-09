// import 'package:path/path.dart';
import 'package:banda/entity/account.dart';
import 'package:banda/entity/entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

// NOTE: Please, write your own SQLite binding on the Kotlin
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

  _seed(Database db) async {
    final List<String> words = ["Purchase", "Rent", "Buy", "Pay", "Lend"];
    final List<double> units = [1000, 2000, 3000, 4000, 5000, 10000];
    final List<Map<String, dynamic>> categories =
        ["Food", "Groceries", "Utilities", "Transfers"]
            .map(
              (name) => {
                "id": Uuid().v4(),
                "name": name,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
            )
            .toList();

    final List<Map<String, dynamic>> accounts =
        [
          {
            "name": "BCA",
            "holder_name": "Fikri Rahmat Nurhidayat",
            "kind": AccountKind.bankAccount.label,
          },
          {
            "name": "LinkAja",
            "holder_name": "Fikri Rahmat Nurhidayat",
            "kind": AccountKind.ewallet.label,
          },
          {
            "name": "GoPay",
            "holder_name": "Fikri Rahmat Nurhidayat",
            "kind": AccountKind.ewallet.label,
          },
          {
            "name": "BRI",
            "holder_name": "Dhea Arintiara",
            "kind": AccountKind.bankAccount.label,
          },
          {
            "name": "GoPay",
            "holder_name": "Dhea Arintiara",
            "kind": AccountKind.ewallet.label,
          },
        ].map((a) {
          a["id"] = Uuid().v4();
          a["created_at"] = DateTime.now().toIso8601String();
          a["updated_at"] = DateTime.now().toIso8601String();
          return a;
        }).toList();

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var category in categories) {
        batch.insert('categories', category);
      }

      await batch.commit(noResult: true);
    });

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var account in accounts) {
        batch.insert('accounts', account);
      }

      await batch.commit(noResult: true);
    });

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var i = 0; i < 2; i++) {
        final unit = units[i % units.length];
        final word = words[i % words.length];
        final category = categories[i % categories.length];
        final account = accounts[i % accounts.length];
        final status = EntryStatus.values[i % EntryStatus.values.length];

        batch.insert("entries", {
          "id": Uuid().v4(),
          "note": "$word ${category["name"]} using ${account["name"]}",
          "amount": (i + 1) * unit,
          "timestamp": DateTime.now().toIso8601String(),
          "status": status.label,
          "category_id": category["id"],
          "account_id": account["id"],
          "created_at": DateTime.now().toIso8601String(),
          "updated_at": DateTime.now().toIso8601String(),
        });
      }

      await batch.commit(noResult: true);
    });

    await db.transaction((txn) async {
      final batch = txn.batch();
      final category = categories.firstWhere(
        (category) => category["name"] == "Transfers",
      );

      for (var i = 0; i < 2; i++) {
        final unit = units[i % units.length];
        final from = accounts[i % accounts.length];
        final to = accounts[(i + 1) % accounts.length];
        final status = EntryStatus.values[i % EntryStatus.values.length];
        final amount = (i + 1) * unit;

        final fromEntry = {
          "id": Uuid().v4(),
          "note": "Transfer to ${to["holder_name"]}: ${to["name"]}",
          "amount": amount * -1,
          "timestamp": DateTime.now().toIso8601String(),
          "status": status.label,
          "category_id": category["id"],
          "account_id": from["id"],
          "created_at": DateTime.now().toIso8601String(),
          "updated_at": DateTime.now().toIso8601String(),
        };

        final toEntry = {
          "id": Uuid().v4(),
          "note": "Transfer from ${from["holder_name"]}: ${from["name"]}",
          "amount": amount,
          "timestamp": DateTime.now().toIso8601String(),
          "status": status.label,
          "category_id": category["id"],
          "account_id": to["id"],
          "created_at": DateTime.now().toIso8601String(),
          "updated_at": DateTime.now().toIso8601String(),
        };

        batch.insert("entries", fromEntry);
        batch.insert("entries", toEntry);

        batch.insert("transfers", {
          "id": Uuid().v4(),
          "note":
              "Transfer from ${from["holder_name"]}: ${from["name"]} to ${to["holder_name"]}: ${to["name"]}",
          "amount": amount,
          "timestamp": DateTime.now().toIso8601String(),
          "from_entry_id": fromEntry["id"],
          "to_entry_id": toEntry["id"],
          "created_at": DateTime.now().toIso8601String(),
          "updated_at": DateTime.now().toIso8601String(),
        });
      }

      await batch.commit(noResult: true);
    });
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS accounts (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            kind TEXT NOT NULL,
            holder_name TEXT NOT NULL,
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

    await db.execute('''
          CREATE TABLE IF NOT EXISTS transfers (
            id TEXT PRIMARY KEY,
            note TEXT NOT NULL,
            amount REAL NOT NULL,
            timestamp TEXT NOT NULL,
            from_entry_id TEXT NOT NULL REFERENCES entries (id),
            to_entry_id TEXT NOT NULL REFERENCES entries (id),
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

    await _seed(db);
  }

  Future<Database> _init() async {
    // final dbPath = await getDatabasesPath();
    // final path = join(dbPath, 'bandaio.db');
    return await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: _onCreate,
    );
  }
}
