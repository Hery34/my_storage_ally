import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/models/box_model.dart';

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
}
