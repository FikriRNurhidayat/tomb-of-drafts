import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyText extends StatelessWidget {
  final double amount;
  final String currency;
  final formatter = NumberFormat("#,##0.00", "en_US");

  MoneyText(this.amount, {super.key, this.currency = 'IDR'});

  Color getColor() {
    return amount >= 0 ? Colors.green : Colors.red;
  }

  String getText() {
    var symbol = amount >= 0 ? "+" : "-";
    var amountText = formatter
        .format(amount)
        .replaceAll(",", " ")
        .replaceAll("-", "");
    return '$symbol $amountText $currency';
  }

  @override
  Widget build(BuildContext context) {
    return Text(getText(), style: TextStyle(color: getColor()));
  }
}
