import 'package:banda/entity/category.dart';
import "package:banda/repositories/repository.dart";

class CategoryRepository extends Repository {
  CategoryRepository._(super.db);

  static Future<CategoryRepository> build() async {
    final db = await Repository.connect();
    return CategoryRepository._(db);
  }

  Future<Category> create({required String name}) async {
    final id = Repository.getId();
    final now = DateTime.now();

    await db.insert("categories", {
      "id": id,
      "name": name,
      "deletable": 1,
      "created_at": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
    });

    return Category(
      id: id,
      name: name,
      deletable: true,
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
    );
  }

  Future<Category?> update({required String id, required String name}) async {
    final now = DateTime.now();

    await db.update(
      "categories",
      {"name": name, "updated_at": now.toIso8601String()},
      where: "id = ? AND deleted_at IS NULL",
      whereArgs: [id],
    );

    final List<Map> rows = await db.query(
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
    final List<Map> rows = await db.query(
      "categories",
      where: "id = ? AND deleted_at IS NULL",
      whereArgs: [id],
    );
    if (rows.isEmpty) {
      return null;
    }

    return Category.fromRow(rows.first);
  }

  Future<List<Category>> search() async {
    final List<Map> rows = await db.query(
      "categories",
      where: "deleted_at IS NULL",
    );
    return rows.map((row) => Category.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    await db.delete(
      "categories",
      where: "id = ? AND deletable = TRUE",
      whereArgs: [id],
    );
  }
}
