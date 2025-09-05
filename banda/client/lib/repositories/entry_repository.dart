import 'package:banda/entity/entry.dart';
import 'package:banda/repositories/repository.dart';

class EntryRepository extends Repository {
  EntryRepository._(super.db);

  static Future<EntryRepository> build() async {
    final db = await Repository.connect();
    return EntryRepository._(db);
  }

  Future<Entry> create({
    required String note,
    required double amount,
    required EntryStatus status,
    required DateTime timestamp,
    required String accountId,
    required String categoryId,
  }) async {
    final id = Repository.getId();
    final now = DateTime.now();

    final category = await _getCategory(categoryId);
    if (category == null) {
      throw UnimplementedError();
    }

    final account = await _getAccount(accountId);
    if (account == null) {
      throw UnimplementedError();
    }

    await db.insert("entries", {
      "id": id,
      "note": note,
      "amount": amount,
      "timestamp": timestamp.toIso8601String(),
      "status": status.toString(),
      "category_id": category["id"],
      "account_id": account["id"],
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    });

    return Entry(
      id: id,
      note: note,
      amount: amount,
      timestamp: timestamp,
      status: status,
      categoryId: categoryId,
      categoryName: category["name"],
      accountId: accountId,
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

    final updated = await db.update(
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
    final List<Map> rows = await db.rawQuery(
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
    final List<Map> rows = await db.rawQuery("""
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
    await db.delete("entries", where: "id = ?", whereArgs: [id]);
  }

  Future<Map?> _getCategory(String id) async {
    final List<Map> rows = await db.query(
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
    final List<Map> rows = await db.query(
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
