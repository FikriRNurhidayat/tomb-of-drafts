enum EntryStatus { pending, completed }

class Entry {
  final String id;
  final String note;
  final double amount;
  final EntryStatus status;
  final DateTime timestamp;
  final String accountId;
  final String accountName;
  final String categoryId;
  final String categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Entry({
    required this.id,
    required this.note,
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.accountId,
    required this.accountName,
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  static EntryStatus parseStatus(String value) =>
      EntryStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => throw Exception('Unknown status: $value'),
      );

  factory Entry.fromRow(Map<dynamic, dynamic> row) {
    return Entry(
      id: row["id"],
      note: row["note"],
      amount: row["amount"],
      status: parseStatus(row["status"]),
      timestamp: DateTime.parse(row["timestamp"]),
      accountId: row["account_id"],
      accountName: row["account_name"],
      categoryId: row["category_id"],
      categoryName: row["category_name"],
      createdAt: DateTime.parse(row["created_at"]),
      updatedAt: DateTime.parse(row["updated_at"]),
    );
  }
}
