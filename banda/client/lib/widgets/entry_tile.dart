import 'package:banda/widgets/money_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  final DateTime timestamp;
  final String category;
  final String note;
  final double amount;
  final dateFormatter = DateFormat("d MMMM yyy");

  EntryTile(
    this.note, {
    super.key,
    required this.amount,
    required this.category,
    required this.timestamp,
  });

  String getDate() {
    return dateFormatter.format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(category, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        note,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MoneyText(amount),
          Text(getDate(), style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}
