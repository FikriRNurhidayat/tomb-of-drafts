import 'package:banda/entity/account.dart';
import 'package:banda/providers/account_provider.dart';
import 'package:banda/views/edit_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Please Confirm"),
              content: const Text(
                "Are you sure you want to remove this account?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final accountProvider = context.read<AccountProvider>();

                    accountProvider.remove(account.id);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => EditAccountScreen(account: account),
          ),
        );
      },
      visualDensity: VisualDensity.compact,
      leading: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: icon(account.kind),
      ),
      title: Text(account.name),
      subtitle: Text(account.holderName),
    );
  }
}
