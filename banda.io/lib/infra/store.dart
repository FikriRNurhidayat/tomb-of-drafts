import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class Store {
  static final Store _instance = Store._internal();
  static Database? _db;
  factory Store() => _instance;

  Store._internal();

  static Future<String> getDir() async {
    final appDir = await getApplicationSupportDirectory();
    final dbDir = Directory(join(appDir.parent.path, 'databases'));
    if (!dbDir.existsSync()) dbDir.createSync(recursive: true);
    return dbDir.path;
  }

  static Future<String> getPath() async {
    return join(await Store.getDir(), "bandaio.db");
  }

  Future<Database> get connection async {
    if (_db != null) return _db!;
    _db = sqlite3.open(await Store.getPath());
    return _db!;
  }
}
