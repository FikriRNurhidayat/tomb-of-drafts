import 'package:banda/entity/transfer.dart';
import 'package:banda/widgets/money_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferTile extends StatelessWidget {
  final Transfer transfer;
  final DateFormat dateFormat = DateFormat("d MMM yyyy");

  TransferTile(this.transfer, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From', style: theme.textTheme.titleSmall),
                Text(transfer.fromAccountName, style: theme.textTheme.titleMedium!.apply(fontFamily: theme.textTheme.headlineSmall!.fontFamily, color: theme.colorScheme.error)),
                Text(
                  transfer.fromAccountHolderName,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),

          Column(children: [Icon(Icons.chevron_right)]),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MoneyText(transfer.amount, useSymbol: false),
                Text(
                  dateFormat.format(transfer.timestamp),
                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Column(children: [Icon(Icons.chevron_right)]),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To', style: theme.textTheme.titleSmall),
                Text(transfer.toAccountName, style: theme.textTheme.titleMedium!.apply(fontFamily: theme.textTheme.headlineSmall!.fontFamily, color: theme.colorScheme.primary)),
                Text(
                  transfer.toAccountHolderName,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
