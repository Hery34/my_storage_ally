/*
import 'package:my_storage_ally/database/box_fields.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:sqflite/sqflite.dart';

class BoxDatabase {
  static final BoxDatabase instance = BoxDatabase._internal();

  static Database? _database;

  BoxDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/box.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${BoxFields.tableName} (
          ${BoxFields.id} ${BoxFields.idType},
          ${BoxFields.boxNumber} ${BoxFields.boxNumberType},
          ${BoxFields.isFavorite} ${BoxFields.boxNumberType},
          ${BoxFields.createdTime} ${BoxFields.createdTimeType}
        )
      ''');
  }

  Future<BoxModel> create(BoxModel box) async {
    final db = await instance.database;
    final id = await db.insert(BoxFields.tableName, box.toJson());
    return box.copy(id: id);
  }

  Future<BoxModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      BoxFields.tableName,
      columns: BoxFields.values,
      where: '${BoxFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BoxModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<BoxModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${BoxFields.createdTime} DESC';
    final result = await db.query(BoxFields.tableName, orderBy: orderBy);
    return result.map((json) => BoxModel.fromJson(json)).toList();
  }

  Future<int> update(BoxModel note) async {
    final db = await instance.database;
    return db.update(
      BoxFields.tableName,
      note.toJson(),
      where: '${BoxFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      BoxFields.tableName,
      where: '${BoxFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
*/
