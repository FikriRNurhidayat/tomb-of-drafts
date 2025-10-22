import 'package:banda/entity/category.dart';
import "package:banda/repositories/repository.dart";
import 'package:sqlite3/sqlite3.dart';

class CategoryRepository extends Repository {
  CategoryRepository._(super.db);

  static Future<CategoryRepository> build() async {
    final db = await Repository.connect();
    return CategoryRepository._(db);
  }

  Future<Category> create({required String name}) async {
    final id = Repository.getId();
    final now = DateTime.now();

    db.execute(
      "INSERT INTO categories (id, name, deletable, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
      [id, name, 1, now.toIso8601String(), now.toIso8601String()],
    );

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

    db.execute("UPDATE categories SET name = ?, updated_at = ? WHERE id = ?", [
      name,
      now.toIso8601String(),
      id,
    ]);

    return get(id);
  }

  Future<Category?> get(String id) async {
    final ResultSet rows = db.select("SELECT * FROM categories WHERE id = ?", [
      id,
    ]);

    if (rows.isEmpty) {
      return null;
    }

    return Category.fromRow(rows.first);
  }

  Future<List<Category>> search() async {
    final ResultSet rows = db.select("SELECT * FROM categories");
    return rows.map((row) => Category.fromRow(row)).toList();
  }

  Future<void> delete(String id) async {
    db.execute("DELETE FROM categories WHERE id = ?", [1]);
  }
}
