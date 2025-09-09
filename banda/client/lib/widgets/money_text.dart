import 'package:flutter/material.dart';

class MoneyText extends StatelessWidget {
  final double amount;
  final String currency;
  final bool useSymbol;

  const MoneyText(
    this.amount, {
    super.key,
    this.currency = 'IDR',
    this.useSymbol = true,
  });

  Color getColor(BuildContext context) {
    final theme = Theme.of(context);
    return amount >= 0 ? theme.colorScheme.primary : theme.colorScheme.error;
  }

  String formatNumber(num number) {
    final n = number.abs();

    if (n >= 1e9) {
      return '${(n / 1e9).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B';
    }
    if (n >= 1e6) {
      return '${(n / 1e6).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
    }
    if (n >= 1e3) {
      return '${(n / 1e3).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
    }

    return n.toString();
  }

  String getText() {
    var amountText = formatNumber(amount);
    if (useSymbol) {
      var symbol = amount >= 0 ? "+" : "-";
      return '$symbol $amountText $currency';
    }

    return "$amountText $currency";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      getText(),
      style: theme.textTheme.titleMedium?.merge(
        TextStyle(color: getColor(context)),
      ),
    );
  }
}
