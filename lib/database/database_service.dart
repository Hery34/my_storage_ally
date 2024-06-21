import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/item_database.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  factory DatabaseService() => instance;

  DatabaseService._internal();

  late final AppDatabase _database;
  late final BoxDatabase boxDatabase;
  late final ItemDatabase itemDatabase;

  void init() {
    _database = AppDatabase.instance;
    boxDatabase = BoxDatabase(_database);
    itemDatabase = ItemDatabase(_database);
  }
}
