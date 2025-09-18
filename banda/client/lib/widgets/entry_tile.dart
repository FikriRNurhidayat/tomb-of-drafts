import 'package:banda/widgets/money_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  final DateTime timestamp;
  final String category;
  final String note;
  final double amount;
  final dateFormatter = DateFormat("yyyy/MM/dd");

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
      dense: true,
      title: Text(category, style: theme.textTheme.titleSmall),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            note,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          Text(
            getDate(),
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
      trailing: MoneyText(amount),
    );
  }
}
