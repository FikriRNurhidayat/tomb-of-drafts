import 'package:banda/entity/entry.dart';
import 'package:banda/repositories/repository.dart';
import 'package:sqlite3/sqlite3.dart';

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

    db.execute(
      "INSERT INTO entries (id, note, amount, timestamp, status, category_id, account_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        id,
        note,
        amount,
        timestamp.toIso8601String(),
        status.label,
        category["id"],
        account["id"],
        now.toIso8601String(),
        now.toIso8601String(),
      ],
    );

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
      accountHolderName: account["holder_name"],
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

    db.execute(
      "UPDATE entries SET note = ?, amount = ?, status = ?, timestamp = ?, category_id = ?, account_id = ?, updated_at = ? WHERE id = ?",
      [
        note,
        amount,
        status.label,
        timestamp.toIso8601String(),
        categoryId,
        accountId,
        now.toIso8601String(),
        id,
      ],
    );

    return get(id);
  }

  Future<Entry?> get(String id) async {
    final ResultSet rows = db.select(
      """
      SELECT
        entries.id,
        entries.note,
        entries.amount,
        entries.timestamp,
        entries.status,
        entries.category_id,
        categories.name AS category_name,
        entries.account_id,
        accounts.name AS account_name,
        accounts.holder_name AS account_holder_name,
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
    final ResultSet rows = db.select("""
          SELECT
            entries.id,
            entries.note,
            entries.amount,
            entries.timestamp,
            entries.status,
            entries.category_id,
            categories.name AS category_name,
            entries.account_id,
            accounts.name AS account_name,
            accounts.holder_name AS account_holder_name,
            entries.created_at,
            entries.updated_at
          FROM entries
          INNER JOIN categories ON categories.id = entries.category_id 
          INNER JOIN accounts ON accounts.id = entries.account_id 
          ORDER BY entries.timestamp DESC
          """);

    return rows.map((row) => Entry.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    db.execute("DELETE FROM entries WHERE id = ?", [id]);
  }

  Future<Map?> _getCategory(String id) async {
    final ResultSet rows = db.select("SELECT * FROM categories WHERE id = ?", [
      id,
    ]);

    if (rows.isEmpty) {
      return null;
    }

    return rows.first;
  }

  Future<Map?> _getAccount(String id) async {
    final ResultSet rows = db.select("SELECT * FROM accounts WHERE id = ?", [
      id,
    ]);

    if (rows.isEmpty) {
      return null;
    }

    return rows.first;
  }
}
