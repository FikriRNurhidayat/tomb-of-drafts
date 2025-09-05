import 'package:banda/entity/account.dart';
import 'package:banda/providers/account_provider.dart';
import 'package:banda/widgets/account_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAccountScreen extends StatefulWidget {
  const ListAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ListAccountScreenState();
}

class _ListAccountScreenState extends State<ListAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return FutureBuilder(
      future: accountProvider.search(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final Account account = snapshot.data![index];
              return AccountTile(account);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
