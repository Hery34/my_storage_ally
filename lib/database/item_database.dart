import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/database/item_fields.dart';
import 'package:my_storage_ally/models/item_model.dart';

class ItemDatabase {
  final AppDatabase _database;
  ItemDatabase(this._database);

  Future<int> createItem(ItemModel item) async {
    final db = await _database.database;
    return await db.insert('items', item.toJson());
  }

  Future<List<ItemModel>> readAllItems() async {
    final db = await _database.database;
    final result = await db.query('items');
    return result.map((json) => ItemModel.fromJson(json)).toList();
  }

  Future<List<ItemModel>> readItemsByBoxId(int boxId) async {
    final db = await _database.database;
    final result = await db.query(
      'items',
      where: 'box_id = ?',
      whereArgs: [boxId],
    );
    return result.map((json) => ItemModel.fromJson(json)).toList();
  }

  Future<ItemModel?> readItem(int id) async {
    final db = await _database.database;
    final result = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return ItemModel.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<int> updateItem(ItemModel item) async {
    final db = await _database.database;
    return await db.update(
      'items',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await _database.database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateItemBox(int itemId, int? boxId) async {
    final db = await _database.database;
    return db.update(
      ItemFields.tableName,
      {ItemFields.boxId: boxId},
      where: '${ItemFields.id} = ?',
      whereArgs: [itemId],
    );
  }
}
