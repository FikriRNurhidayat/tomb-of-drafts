import 'dart:convert';

import 'package:banda/entity/entry.dart';
import 'package:banda/providers/entry_provider.dart';
import 'package:banda/widgets/empty.dart';
import 'package:banda/widgets/entry_tile.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class ListEntryScreen extends StatefulWidget {
  const ListEntryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ListEntryScreenState();
}

class _ListEntryScreenState extends State<ListEntryScreen> {
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

          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final Entry entry = snapshot.data![index];
              return EntryTile(entry);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
