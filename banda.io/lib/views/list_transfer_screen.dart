import 'package:banda/entity/transfer.dart';
import 'package:banda/providers/transfer_provider.dart';
import 'package:banda/widgets/transfer_tile.dart';
import 'package:banda/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTransferScreen extends StatefulWidget {
  const ListTransferScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ListTransferScreenState();
}

class _ListTransferScreenState extends State<ListTransferScreen> {
  @override
  Widget build(BuildContext context) {
    final transferProvider = context.watch<TransferProvider>();

    return FutureBuilder(
      future: transferProvider.search(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.isEmpty) {
            return Empty("Transfers you add appear here", icon: Icons.wallet);
          }

          return SafeArea(
            child: ListView.separated(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final Transfer transfer = snapshot.data![index];
                return TransferTile(transfer);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  thickness: 1,
                );
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
