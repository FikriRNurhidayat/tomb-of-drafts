import 'package:banda/services/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class Repository {
  final Database db;
  Repository(this.db);
  static Future<Database> connect() => DB().connection;

  static String getId() {
    return Uuid().v4();
  }

  static String getTime() {
    return DateTime.now().toIso8601String();
  }
}
