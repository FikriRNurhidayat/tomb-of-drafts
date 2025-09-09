import 'package:banda/entity/entry.dart';
import 'package:banda/entity/transfer.dart';
import 'package:banda/repositories/repository.dart';
import 'package:uuid/uuid.dart';

class TransferRepository extends Repository {
  TransferRepository._(super.db);

  static Future<TransferRepository> build() async {
    final db = await Repository.connect();
    return TransferRepository._(db);
  }

  Future<Transfer> create({
    required double amount,
    required DateTime timestamp,
    required String fromId,
    required String toId,
  }) async {
    final id = Repository.getId();
    final now = DateTime.now();

    final category = await _getCategoryByName("Transfers");
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

    await db.transaction((txn) async {
      final batch = txn.batch();

      batch.insert("entries", fromEntry);
      batch.insert("entries", toEntry);

      batch.insert("transfers", {
        "id": id,
        "note": note,
        "amount": amount,
        "timestamp": timestamp.toIso8601String(),
        "from_entry_id": fromEntry["id"],
        "to_entry_id": toEntry["id"],
        "created_at": now.toIso8601String(),
        "updated_at": now.toIso8601String(),
      });

      await batch.commit(noResult: true);
    });

    final transfer = await get(id);
    if (transfer == null) {
      throw UnimplementedError();
    }

    return transfer;
  }

  Future<Transfer?> update({
    required String id,
    required double amount,
    required DateTime timestamp,
  }) async {
    final now = DateTime.now();

    final updated = await db.update(
      "transfers",
      {
        "amount": amount,
        "timestamp": timestamp.toString(),
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

  Future<Transfer?> get(String id) async {
    final List<Map> rows = await db.rawQuery(
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
    final List<Map> rows = await db.rawQuery("""
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
        """);

    return rows.map((row) => Transfer.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    await db.transaction((txn) async {
      final rows = await txn.query(
        "transfers",
        where: "id = ?",
        whereArgs: [id],
      );
      if (rows.isEmpty) return;

      final row = rows.first;
      final batch = txn.batch();
      batch.delete("transfers", where: "id = ?", whereArgs: [id]);
      batch.delete("entries", where: "id IN (?, ?)", whereArgs: [row["from_entry_id"], row["to_entry_id"]]);

      await batch.commit(noResult: true);
    });
  }

  Future<Map?> _getCategoryByName(String name) async {
    final List<Map> rows = await db.query(
      "categories",
      where: "name = ?",
      whereArgs: [name],
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
