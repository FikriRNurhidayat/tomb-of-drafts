class Label {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Label({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Label.fromRow(Map<dynamic, dynamic> map) {
    return Label(
      id: map["id"],
      name: map["name"],
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
    );
  }
}
