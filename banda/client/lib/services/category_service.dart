import 'package:banda/entity/category.dart';
import 'package:banda/services/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  final Database _db;

  CategoryService._(this._db);

  static Future<CategoryService> build() async {
    final db = await DB().connection;
    return CategoryService._(db);
  }

  Future<Category> create({required String name}) async {
    final id = Uuid().v4();
    final now = DateTime.now();

    await _db.insert("categories", {
      "id": id,
      "name": name,
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    });

    return Category(id: id, name: name, createdAt: now, updatedAt: now);
  }

  Future<Category?> update({required String id, required String name}) async {
    final now = DateTime.now();

    await _db.update(
      "categories",
      {"name": name, "updated_at": now.toIso8601String()},
      where: "id = ?",
      whereArgs: [id],
    );

    final List<Map> rows = await _db.query(
      "categories",
      where: "id = ?",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Category.fromRow(rows.first);
  }

  Future<Category?> get(String id) async {
    final List<Map> rows = await _db.query(
      "categories",
      where: "id = ?",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Category.fromRow(rows.first);
  }

  Future<List<Category>> search() async {
    final List<Map> rows = await _db.query("categories");
    return rows.map((row) => Category.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    await _db.delete("categories", where: "id = ?", whereArgs: [id]);
  }
}
