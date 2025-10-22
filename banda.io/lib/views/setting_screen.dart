import 'dart:io';

import 'package:banda/infra/store.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<void> _import() async {
    final dbTargetDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getDownloadsDirectory();

    if (dbTargetDir == null) {
      print("Target directory doesn't exists");
      return;
    }

    final dbTargetFile = File('${dbTargetDir.path}/import.bandaio.db');
    final dbSourcePath = await Store.getPath();
    final dbSourceFile = File(dbSourcePath);
    await dbTargetFile.copy(dbSourceFile.path);
    print("Imported from ${dbTargetFile.path}");
  }

  Future<void> _export() async {
    final dbSourcePath = await Store.getPath();
    final dbSourceFile = File(dbSourcePath);

    final dbTargetDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getDownloadsDirectory();

    if (dbTargetDir == null) {
      print("Target directory doesn't exists");
      return;
    }

    final dbTargetFile = File('${dbTargetDir.path}/export.bandaio.db');
    await dbSourceFile.copy(dbTargetFile.path);
    print("Exported to ${dbTargetFile.path}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Export"),
          trailing: IconButton(onPressed: _export, icon: Icon(Icons.download)),
        ),
        ListTile(
          title: Text("Import"),
          trailing: IconButton(onPressed: _import, icon: Icon(Icons.upload)),
        ),
      ],
    );
  }
}
