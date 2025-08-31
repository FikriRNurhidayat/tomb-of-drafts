import 'package:banda/entity/entry.dart';
import 'package:banda/services/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/v4.dart';

class EntryService {
  final Database _db;

  EntryService._(this._db);

  static Future<EntryService> build() async {
    final db = await DB().connection;
    return EntryService._(db);
  }

  Future<Entry> create({
    required String note,
    required double amount,
    required EntryStatus status,
    required DateTime timestamp,
    required String categoryId,
    required String accountId,
  }) async {
    final id = UuidV4();
    final now = DateTime.now();

    final category = await _getCategory(categoryId);
    if (category == null) {
      throw UnimplementedError();
    }

    final account = await _getAccount(accountId);
    if (account == null) {
      throw UnimplementedError();
    }

    await _db.insert("entries", {
      "id": id.toString(),
      "note": note,
      "amount": amount,
      "status": status.toString(),
      "timestamp": timestamp.toString(),
      "category_id": categoryId,
      "account_id": accountId,
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    });

    return Entry(
      id: id.toString(),
      note: note,
      amount: amount,
      status: status,
      timestamp: timestamp,
      categoryId: category["id"],
      categoryName: category["name"],
      accountId: account["id"],
      accountName: account["name"],
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<Entry?> update({
    required String id,
    required String note,
    required double amount,
    required EntryStatus status,
    required DateTime timestamp,
    required String categoryId,
    required String accountId,
  }) async {
    final now = DateTime.now();

    final updated = await _db.update(
      "entries",
      {
        "note": note,
        "amount": amount,
        "status": status.toString(),
        "timestamp": timestamp.toString(),
        "category_id": categoryId,
        "account_id": accountId,
        "updated_at": now.toIso8601String(),
      },
      where: "id = ?",
      whereArgs: [id],
    );

    if (updated == 0) {
      return null;
    }

    return get(id);
  }

  Future<Entry?> get(String id) async {
    final List<Map> rows = await _db.rawQuery(
      """
      SELECT
        entries.id,
        entries.note,
        entries.amount,
        entries.timestamp,
        entries.status,
        entries.category_id,
        categories.name,
        entries.account_id,
        accounts.name,
        entries.created_at,
        entries.updated_at
      FROM entries
      INNER JOIN categories ON categories.id = entries.category_id 
      INNER JOIN accounts ON accounts.id = entries.account_id 
      WHERE entries.id = ?
      """,
      [id],
    );

    if (rows.isEmpty) {
      return null;
    }

    return Entry.fromRow(rows.first);
  }

  Future<List<Entry>> search() async {
    final List<Map> rows = await _db.rawQuery("""
      SELECT
        entries.id,
        entries.note,
        entries.amount,
        entries.timestamp,
        entries.status,
        entries.category_id,
        categories.name,
        entries.account_id,
        accounts.name,
        entries.created_at,
        entries.updated_at
      FROM entries
      INNER JOIN categories ON categories.id = entries.category_id 
      INNER JOIN accounts ON accounts.id = entries.account_id 
      """);
    return rows.map((row) => Entry.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    await _db.delete("categories", where: "id = ?", whereArgs: [id]);
  }

  Future<Map?> _getCategory(String id) async {
    final List<Map> rows = await _db.query(
      "categories",
      where: "id = ?",
      whereArgs: [id],
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first;
  }

  Future<Map?> _getAccount(String id) async {
    final List<Map> rows = await _db.query(
      "accounts",
      where: "id = ?",
      whereArgs: [id],
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first;
  }
}
