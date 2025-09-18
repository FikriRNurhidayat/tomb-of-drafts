import 'package:banda/entity/label.dart';
import "package:banda/repositories/repository.dart";

class LabelRepository extends Repository {
  LabelRepository._(super.db);

  static Future<LabelRepository> build() async {
    final db = await Repository.connect();
    return LabelRepository._(db);
  }

  Future<Label> create({required String name}) async {
    final id = Repository.getId();
    final now = DateTime.now();

    await db.insert("labels", {
      "id": id,
      "name": name,
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    });

    return Label(id: id, name: name, createdAt: now, updatedAt: now);
  }

  Future<Label?> update({required String id, required String name}) async {
    final now = DateTime.now();

    await db.update(
      "labels",
      {"name": name, "updated_at": now.toIso8601String()},
      where: "id = ?",
      whereArgs: [id],
    );

    final List<Map> rows = await db.query(
      "labels",
      where: "id = ?",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Label.fromRow(rows.first);
  }

  Future<Label?> get(String id) async {
    final List<Map> rows = await db.query(
      "labels",
      where: "id = ?",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Label.fromRow(rows.first);
  }

  Future<List<Label>> search() async {
    final List<Map> rows = await db.query("labels");
    return rows.map((row) => Label.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    await db.delete("labels", where: "id = ?", whereArgs: [id]);
  }
}
