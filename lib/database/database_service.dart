import 'package:my_storage_ally/database/item_database.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  factory DatabaseService() => instance;

  DatabaseService._internal();

  final ItemDatabase database = ItemDatabase.instance;
}
