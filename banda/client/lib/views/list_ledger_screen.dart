import 'dart:convert';

import 'package:banda/entity/entry.dart';
import 'package:banda/providers/entry_provider.dart';
import 'package:banda/widgets/empty.dart';
import 'package:banda/widgets/entry_tile.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class ListLedgerScreen extends StatefulWidget {
  const ListLedgerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ListLedgerScreenState();
}

class _ListLedgerScreenState extends State<ListLedgerScreen> {
  @override
  Widget build(BuildContext context) {
    final entryProvider = context.watch<EntryProvider>();

    return FutureBuilder(
      future: entryProvider.search(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Empty(
              "Ledger entries you add appear here.",
              icon: Icons.receipt,
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final Entry entry = snapshot.data![index];
              return EntryTile(
                entry.note,
                amount: entry.amount,
                category: entry.categoryName,
                account: "${entry.accountName} (${entry.accountHolderName})",
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
