import 'package:my_storage_ally/database/box_fields.dart';
import 'package:my_storage_ally/database/item_fields.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  AppDatabase._init();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('app_database.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(filePath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
       CREATE TABLE ${ItemFields.tableName} (
          ${ItemFields.id} ${ItemFields.idType},
          ${ItemFields.itemName} ${ItemFields.itemNameType},
          ${ItemFields.itemNumber} ${ItemFields.itemNumberType},
          ${ItemFields.boxNumber} ${ItemFields.boxNumberType},
          ${ItemFields.isFavorite} ${ItemFields.itemNumberType},
          ${ItemFields.createdTime} ${ItemFields.itemNameType}
        )
      ''');
    return await db.execute('''
        CREATE TABLE ${BoxFields.tableName} (
          ${BoxFields.id} ${BoxFields.idBoxType},
          ${BoxFields.boxNumber} ${BoxFields.boxNumberType},
          ${BoxFields.isFavorite} ${BoxFields.boxNumberType},
          ${BoxFields.createdTime} ${BoxFields.createdTimeType}
        )
      ''');
  }
}
