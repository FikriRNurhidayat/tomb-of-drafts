class Category {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromRow(Map<dynamic, dynamic> map) {
    return Category(
      id: map["id"],
      name: map["name"],
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
    );
  }
}
