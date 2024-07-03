import 'package:my_storage_ally/database/item_fields.dart';

class ItemModel {
  late final int? id;
  final String itemName;
  final int itemNumber;
  final int? boxId;
  final bool isFavorite;
  final DateTime? createdTime;
  final String? imagePath;
  ItemModel({
    this.id,
    required this.itemName,
    required this.itemNumber,
    required this.boxId,
    this.isFavorite = false,
    this.createdTime,
    this.imagePath,
  });

  Map<String, Object?> toJson() => {
        ItemFields.id: id,
        ItemFields.itemName: itemName,
        ItemFields.itemNumber: itemNumber,
        ItemFields.boxId: boxId,
        ItemFields.isFavorite: isFavorite ? 1 : 0,
        ItemFields.createdTime: createdTime?.toIso8601String(),
        ItemFields.imagePath: imagePath,
      };

  factory ItemModel.fromJson(Map<String, Object?> json) => ItemModel(
        id: json[ItemFields.id] as int?,
        itemName: json[ItemFields.itemName] as String,
        itemNumber: json[ItemFields.itemNumber] as int,
        boxId: json[ItemFields.boxId] as int?,
        isFavorite: json[ItemFields.isFavorite] == 1,
        createdTime:
            DateTime.tryParse(json[ItemFields.createdTime] as String? ?? ''),
        imagePath: json[ItemFields.imagePath] as String?,
      );

  ItemModel copy({
    int? id,
    String? itemName,
    int? itemNumber,
    int? boxId,
    bool? isFavorite,
    DateTime? createdTime,
    String? imagePath,
  }) =>
      ItemModel(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
        itemNumber: itemNumber ?? this.itemNumber,
        boxId: boxId ?? this.boxId,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
        imagePath: imagePath ?? this.imagePath,
      );
}
