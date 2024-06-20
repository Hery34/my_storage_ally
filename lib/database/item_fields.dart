class ItemFields {
  static const String tableName = 'items';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String itemNameType = 'TEXT NOT NULL';
  static const String itemNumberType = 'INTEGER NOT NULL';
  static const String boxIdType = 'INTEGER';
  static const String id = 'id';
  static const String itemName = 'item_name';
  static const String itemNumber = 'item_number';
  static const String boxId = 'box_id';
  static const String isFavorite = 'is_favorite';
  static const String createdTime = 'created_time';
  static const List<String> values = [
    id,
    itemName,
    itemNumber,
    boxId,
    isFavorite,
    createdTime,
  ];
}
