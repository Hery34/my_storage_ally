class BoxFields {
  static const String tableName = 'boxes';
  static const String idBoxType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String boxNumberType = 'TEXT NOT NULL';
  static const String boxDescriptionType = 'TEXT';
  static const String id = 'id';
  static const String boxNumber = 'box_number';
  static const String boxDescription = 'description';
  static const String isFavorite = 'is_favorite';
  static const String createdTime = 'created_time';
  static const String createdTimeType = 'TEXT NOT NULL';

  static const List<String> values = [id, boxNumber, isFavorite, createdTime];
}
