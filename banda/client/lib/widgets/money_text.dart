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

  IconData getSign() {
    return amount >= 0 ? Icons.add : Icons.remove;
  }

  Color getColor(BuildContext context) {
    final theme = Theme.of(context);
    return amount >= 0
        ? theme.colorScheme.onSurface
        : theme.colorScheme.tertiary;
  }

  String formatAmount(double value) {
    return value
        .toStringAsFixed(3)
        .replaceFirst(RegExp(r'\.?0+$'), ''); // trims .000 / .100 etc.
  }

  String getAmount() {
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: useSymbol
              ? Icon(
                  getSign(),
                  size: theme.textTheme.bodySmall!.fontSize,
                  color: getColor(context),
                )
              : null,
        ),
        SizedBox(
          width: 48,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getAmount(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.apply(
                color: getColor(context),
                fontFamily: theme.textTheme.headlineSmall!.fontFamily,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            currency,
            style: theme.textTheme.bodySmall!.apply(
              color: getColor(context),
              fontFamily: theme.textTheme.headlineSmall!.fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
