import 'package:my_storage_ally/database/item_fields.dart';

class ItemModel {
  late final int? id;
  final String itemName;
  final int itemNumber;
  final int boxNumber;
  final bool isFavorite;
  final DateTime? createdTime;
  ItemModel({
    this.id,
    required this.itemName,
    required this.itemNumber,
    required this.boxNumber,
    this.isFavorite = false,
    this.createdTime,
  });

  Map<String, Object?> toJson() => {
        ItemFields.id: id,
        ItemFields.itemName: itemName,
        ItemFields.itemNumber: itemNumber,
        ItemFields.boxNumber: boxNumber,
        ItemFields.isFavorite: isFavorite ? 1 : 0,
        ItemFields.createdTime: createdTime?.toIso8601String(),
      };

  factory ItemModel.fromJson(Map<String, Object?> json) => ItemModel(
        id: json[ItemFields.id] as int?,
        itemName: json[ItemFields.itemName] as String,
        itemNumber: json[ItemFields.itemNumber] as int,
        boxNumber: json[ItemFields.boxNumber] as int,
        isFavorite: json[ItemFields.isFavorite] == 1,
        createdTime:
            DateTime.tryParse(json[ItemFields.createdTime] as String? ?? ''),
      );

  ItemModel copy({
    int? id,
    String? itemName,
    int? itemNumber,
    int? boxNumber,
    bool? isFavorite,
    DateTime? createdTime,
  }) =>
      ItemModel(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
        itemNumber: itemNumber ?? this.itemNumber,
        boxNumber: boxNumber ?? this.boxNumber,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
      );
}
