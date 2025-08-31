import 'package:banda/entity/entry.dart';
import 'package:banda/services/entry_service.dart';
import 'package:banda/widgets/entry_tile.dart';
import 'package:flutter/material.dart';

class LedgerListScreen extends StatefulWidget {
  const LedgerListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LedgerListScreenState();
}

class _LedgerListScreenState extends State<LedgerListScreen> {
  late Future<List<Entry>> _futureEntries;

  @override
  void initState() {
    super.initState();
    _futureEntries = _getEntries();
  }

  Future<List<Entry>> _getEntries() async {
    final entryService = await EntryService.build();
    return await entryService.search();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureEntries,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final Entry entry = snapshot.data![index];
              return EntryTile(
                entry.note,
                amount: entry.amount,
                category: entry.categoryName,
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
