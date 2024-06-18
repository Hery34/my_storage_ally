class BoxFields {
  static const String tableName = 'boxes';
  static const String id = '_id';
  static const String boxNumber = 'box_number';
  static const String isFavorite = 'is_favorite';
  static const String createdTime = 'created_time';

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String boxNumberType = 'INTEGER NOT NULL';
  static const String isFavoriteType = 'INTEGER NOT NULL';
  static const String createdTimeType = 'TEXT NOT NULL';

  static const List<String> values = [id, boxNumber, isFavorite, createdTime];
}
