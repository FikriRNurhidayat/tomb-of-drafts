class Category {
  final String id;
  final String name;
  final bool deletable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Category({
    required this.id,
    required this.name,
    required this.deletable,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Category.fromRow(Map<dynamic, dynamic> row) {
    return Category(
      id: row["id"],
      name: row["name"],
      deletable: row["deletable"] == 1,
      createdAt: DateTime.parse(row["created_at"]),
      updatedAt: DateTime.parse(row["updated_at"]),
      deletedAt: row["deleted_at"],
    );
  }
}
