import "package:banda/entity/account.dart";
import "package:banda/repositories/repository.dart";

class AccountRepository extends Repository {
  AccountRepository._(super.db);

  static Future<AccountRepository> build() async {
    final db = await Repository.connect();
    return AccountRepository._(db);
  }

  Future<Account> create({
    required String name,
    required String holderName,
    required AccountKind kind,
  }) async {
    final id = Repository.getId();
    final now = DateTime.now();

    await db.insert("accounts", {
      "id": id,
      "name": name,
      "holder_name": holderName,
      "kind": kind.label,
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    });

    return Account(
      id: id,
      name: name,
      holderName: holderName,
      kind: kind,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<Account?> update({
    required String id,
    required String name,
    required String holderName,
    required AccountKind kind,
  }) async {
    final now = DateTime.now();

    await db.update(
      "accounts",
      {
        "name": name,
        "holder_name": holderName,
        "kind": kind.label,
        "updated_at": now.toIso8601String(),
      },
      where: "id = ?",
      whereArgs: [id],
    );

    final List<Map> rows = await db.query(
      "accounts",
      where: "id = ?",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Account.fromRow(rows.first);
  }

  Future<Account?> get(String id) async {
    final List<Map> rows = await db.query(
      "accounts",
      where: "id = ?",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Account.fromRow(rows.first);
  }

  Future<List<Account>> search() async {
    final List<Map> rows = await db.query("accounts");
    return rows.map((row) => Account.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    await db.delete("accounts", where: "id = ?", whereArgs: [id]);
  }
}
