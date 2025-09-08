import 'package:banda/widgets/money_text.dart';
import 'package:flutter/material.dart';

class EntryTile extends StatelessWidget {
  final String account;
  final String category;
  final String note;
  final double amount;

  const EntryTile(
    this.note, {
    super.key,
    required this.amount,
    required this.category,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(category),
      subtitle: Text(note, overflow: TextOverflow.ellipsis),
      trailing: Column(
        children: [
          MoneyText(amount),
          Text(account),
        ],
      ),
    );
  }
}
