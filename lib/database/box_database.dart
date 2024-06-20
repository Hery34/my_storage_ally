import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/database/box_fields.dart';

class BoxDatabase {
  final AppDatabase _database;

  BoxDatabase(this._database);

  Future<int> createBox(BoxModel box) async {
    final db = await _database.database;
    return await db.insert('boxes', box.toJson());
  }

  Future<List<BoxModel>> readAllBoxes() async {
    final db = await _database.database;
    final result = await db.query('boxes');
    return result.map((json) => BoxModel.fromJson(json)).toList();
  }

  Future<BoxModel> readBox(int id) async {
    final db = await _database.database;
    final result = await db.query(
      'boxes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return BoxModel.fromJson(result.first);
  }

  Future<int> updateBox(BoxModel box) async {
    final db = await _database.database;
    return await db.update(
      'boxes',
      box.toJson(),
      where: 'id = ?',
      whereArgs: [box.idBox],
    );
  }

  Future<int> deleteBox(int id) async {
    final db = await _database.database;
    return await db.delete(
      'boxes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<BoxModel?> readBoxByItemId(int itemId) async {
    final db = await _database.database;
    final result = await db.rawQuery('''
      SELECT b.* FROM boxes b
      JOIN items i ON b.idBox = i.boxId
      WHERE i.id = ?
    ''', [itemId]);

    if (result.isNotEmpty) {
      return BoxModel.fromJson(result.first);
    } else {
      return null;
    }
  }

   Future<String?> getBoxNameById(int id) async {
    final db = await _database.database;
    final maps = await db.query(
      BoxFields.tableName,
      columns: [BoxFields.boxNumber],
      where: '${BoxFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first[BoxFields.boxNumber] as String?;
    } else {
      return null;
    }
  }
}
