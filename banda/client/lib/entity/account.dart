enum AccountKind {
  bankAccount('Bank Account'),
  ewallet('E-Wallet'),
  cash('Cash');

  final String label;
  const AccountKind(this.label);
}

class Account {
  final String id;
  final String name;
  final String holderName;
  final AccountKind kind;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.id,
    required this.name,
    required this.holderName,
    required this.kind,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromRow(Map<dynamic, dynamic> map) {
    return Account(
      id: map["id"],
      name: map["name"],
      holderName: map["holder_name"],
      kind: AccountKind.values.firstWhere((e) => e.label == map["kind"]),
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
    );
  }
}
