import 'package:banda/entity/entry.dart';
import 'package:banda/entity/transfer.dart';
import 'package:banda/repositories/repository.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

class TransferRepository extends Repository {
  TransferRepository._(super.db);

  static Future<TransferRepository> build() async {
    final db = await Repository.connect();
    return TransferRepository._(db);
  }

  Future<Transfer?> create({
    required double amount,
    required DateTime timestamp,
    required String fromId,
    required String toId,
  }) async {
    final id = Repository.getId();
    final now = DateTime.now();

    final category = await _getCategoryByName("Transfer");
    if (category == null) {
      throw UnimplementedError();
    }

    final fromAccount = await _getAccount(fromId);
    if (fromAccount == null) {
      throw UnimplementedError();
    }

    final toAccount = await _getAccount(toId);
    if (toAccount == null) {
      throw UnimplementedError();
    }

    final fromName = "${fromAccount["holder_name"]}: ${fromAccount["name"]}";
    final toName = "${toAccount["holder_name"]}: ${toAccount["name"]}";

    final note = "Transfer from $fromName to $toName";

    final Map<String, dynamic> fromEntry = {
      "id": Uuid().v4(),
      "note": "Transfer to $toName",
      "amount": amount * -1,
      "status": EntryStatus.done.label,
      "timestamp": timestamp.toIso8601String(),
      "category_id": category["id"],
      "account_id": fromAccount["id"],
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    };

    final Map<String, dynamic> toEntry = {
      "id": Uuid().v4(),
      "note": "Transfer from $fromName",
      "amount": amount,
      "status": EntryStatus.done.label,
      "timestamp": timestamp.toIso8601String(),
      "category_id": category["id"],
      "account_id": toAccount["id"],
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    };

    db.execute("BEGIN TRANSACTION");
    try {
      db.execute(
        "INSERT INTO entries (id, note, amount, status, timestamp, category_id, account_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          fromEntry["id"],
          fromEntry["note"],
          fromEntry["amount"],
          fromEntry["status"],
          fromEntry["timestamp"],
          fromEntry["category_id"],
          fromEntry["account_id"],
          fromEntry["created_at"],
          fromEntry["updated_at"],
        ],
      );

      db.execute(
        "INSERT INTO entries (id, note, amount, status, timestamp, category_id, account_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          toEntry["id"],
          toEntry["note"],
          toEntry["amount"],
          toEntry["status"],
          toEntry["timestamp"],
          toEntry["category_id"],
          toEntry["account_id"],
          toEntry["created_at"],
          toEntry["updated_at"],
        ],
      );

      db.execute(
        "INSERT INTO transfers (id, note, amount, timestamp, from_entry_id, to_entry_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        [
          id,
          note,
          amount,
          timestamp.toIso8601String(),
          fromEntry["id"],
          toEntry["id"],
          now.toIso8601String(),
          now.toIso8601String(),
        ],
      );

      db.execute('COMMIT');
    } catch (e) {
      db.execute('ROLLBACK');
    }

    return get(id);
  }

  Future<Transfer?> update({
    required String id,
    required double amount,
    required DateTime timestamp,
  }) async {
    final now = DateTime.now();

    db.execute(
      "UPDATE transfers SET amount = ?, timestamp = ?, updated_at = ? WHERE id = ?",
      [amount, timestamp.toString(), now.toIso8601String(), id],
    );

    return get(id);
  }

  Future<Transfer?> get(String id) async {
    final ResultSet rows = db.select(
      """
      SELECT
        transfers.id,
        transfers.note,
        transfers.amount,
        transfers.timestamp,
        from_accounts.id AS from_account_id,
        from_accounts.name AS from_account_name,
        from_accounts.holder_name AS from_account_holder_name,
        to_accounts.id AS to_account_id,
        to_accounts.name AS to_account_name,
        to_accounts.holder_name AS to_account_holder_name,
        transfers.created_at,
        transfers.updated_at
      FROM transfers
      INNER JOIN entries AS from_entries ON from_entries.id = transfers.from_entry_id 
      INNER JOIN accounts AS from_accounts ON from_accounts.id = from_entries.account_id 
      INNER JOIN entries AS to_entries ON to_entries.id = transfers.to_entry_id 
      INNER JOIN accounts AS to_accounts ON to_accounts.id = to_entries.account_id 
      WHERE transfers.id = ?
      """,
      [id],
    );

    if (rows.isEmpty) {
      return null;
    }

    return Transfer.fromRow(rows.first);
  }

  Future<List<Transfer>> search() async {
    final ResultSet rows = db.select("""
        SELECT
          transfers.id,
          transfers.note,
          transfers.amount,
          transfers.timestamp,
          from_accounts.id AS from_account_id,
          from_accounts.name AS from_account_name,
          from_accounts.holder_name AS from_account_holder_name,
          to_accounts.id AS to_account_id,
          to_accounts.name AS to_account_name,
          to_accounts.holder_name AS to_account_holder_name,
          transfers.created_at,
          transfers.updated_at
        FROM transfers
        INNER JOIN entries AS from_entries ON from_entries.id = transfers.from_entry_id 
        INNER JOIN accounts AS from_accounts ON from_accounts.id = from_entries.account_id 
        INNER JOIN entries AS to_entries ON to_entries.id = transfers.to_entry_id 
        INNER JOIN accounts AS to_accounts ON to_accounts.id = to_entries.account_id 
        ORDER BY transfers.timestamp DESC
        """);

    return rows.map((row) => Transfer.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    db.execute("BEGIN TRANSACTION");
    try {
      final ResultSet rows = db.select("SELECT * FROM transfers WHERE id = ?", [
        id,
      ]);

      if (rows.isEmpty) {
        db.execute("COMMIT");
        return;
      }

      final row = rows.first;

      db.execute("DELETE FROM transfers WHERE id = ?", [id]);
      db.execute("DELETE FROM entries WHERE id IN (?, ?)", [
        row["from_entry_id"],
        row["to_entry_id"],
      ]);

      db.execute("COMMIT");
    } catch (e) {
      db.execute("ROLLBACK");
    }
  }

  Future<Map?> _getCategoryByName(String name) async {
    final ResultSet rows = db.select(
      "SELECT * FROM categories FROM where name = ?",
      [name],
    );

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
