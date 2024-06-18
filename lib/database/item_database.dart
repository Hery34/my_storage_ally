import 'package:my_storage_ally/database/item_fields.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:sqflite/sqflite.dart';

class ItemDatabase {
  static final ItemDatabase instance = ItemDatabase._internal();

  static Database? _database;

  ItemDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/items.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${ItemFields.tableName} (
          ${ItemFields.id} ${ItemFields.idType},
          ${ItemFields.itemName} ${ItemFields.itemNameType},
          ${ItemFields.itemNumber} ${ItemFields.itemNumberType},
          ${ItemFields.boxNumber} ${ItemFields.boxNumberType},
          ${ItemFields.isFavorite} ${ItemFields.itemNumberType},
          ${ItemFields.createdTime} ${ItemFields.itemNameType}
        )
      ''');
  }

  Future<ItemModel> create(ItemModel item) async {
    final db = await instance.database;
    final id = await db.insert(ItemFields.tableName, item.toJson());
    return item.copy(id: id);
  }

  Future<ItemModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      ItemFields.tableName,
      columns: ItemFields.values,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ItemModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${ItemFields.createdTime} DESC';
    final result = await db.query(ItemFields.tableName, orderBy: orderBy);
    return result.map((json) => ItemModel.fromJson(json)).toList();
  }

  Future<int> update(ItemModel note) async {
    final db = await instance.database;
    return db.update(
      ItemFields.tableName,
      note.toJson(),
      where: '${ItemFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      ItemFields.tableName,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
