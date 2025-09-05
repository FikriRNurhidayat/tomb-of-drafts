import 'package:banda/entity/account.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  final Account account;

  const AccountTile(this.account, {super.key});

  Icon? icon(AccountKind kind) {
    switch (kind) {
      case AccountKind.bankAccount:
        return Icon(Icons.account_balance);
      case AccountKind.ewallet:
        return Icon(Icons.wallet);
      case AccountKind.cash:
        return Icon(Icons.money);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16), child: icon(account.kind)),
      title: Text(account.name),
      subtitle: Text(account.holderName),
      trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
    );
  }
}
