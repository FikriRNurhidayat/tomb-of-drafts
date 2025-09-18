import 'package:banda/entity/transfer.dart';
import 'package:banda/widgets/money_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferTile extends StatelessWidget {
  final Transfer transfer;
  final DateFormat dateFormat = DateFormat("d MMM yyyy");

  TransferTile(this.transfer, {super.key});

  String formatAmount(double value) {
    return value
        .toStringAsFixed(3)
        .replaceFirst(RegExp(r'\.?0+$'), ''); // trims .000 / .100 etc.
  }

  String getAmount(double amount) {
    final n = amount.abs();

    if (n >= 1e9) {
      return '${formatAmount(n / 1e9)}B';
    }
    if (n >= 1e6) {
      return '${formatAmount(n / 1e6)}M';
    }

    if (n >= 1e3) {
      return '${formatAmount(n / 1e3)}K';
    }

    return n.toStringAsFixed(0);
  }

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
                Text(
                  transfer.fromAccountName,
                  style: theme.textTheme.titleMedium!.apply(
                    fontFamily: theme.textTheme.headlineSmall!.fontFamily,
                    color: theme.colorScheme.error,
                  ),
                ),
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
                Text(
                  getAmount(transfer.amount),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium!.apply(
                    fontFamily: theme.textTheme.headlineSmall!.fontFamily,
                  ),
                ),
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
                Text(
                  transfer.toAccountName,
                  style: theme.textTheme.titleMedium!.apply(
                    fontFamily: theme.textTheme.headlineSmall!.fontFamily,
                    color: theme.colorScheme.primary,
                  ),
                ),
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
