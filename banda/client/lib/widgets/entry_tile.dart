import 'package:banda/entity/entry.dart';
import 'package:banda/widgets/money_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  final Entry entry;
  final dateFormatter = DateFormat("yyyy/MM/dd");

  EntryTile(this.entry, {super.key});

  String getDate() {
    return dateFormatter.format(entry.timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Center(child: const Text("Transaction action contexts")),
          ),
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Center(child: const Text("Transaction Detail")),
          ),
        );
      },
      title: Text(entry.categoryName, style: theme.textTheme.titleSmall),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            entry.accountName,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          Text(
            getDate(),
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      trailing: MoneyText(entry.amount),
    );
  }
}
