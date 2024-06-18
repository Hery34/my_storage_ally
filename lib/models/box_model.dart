import 'package:my_storage_ally/database/box_fields.dart';

class BoxModel {
  final int? id;
  final int boxNumber;
  final int isFavorite;
  final String createdTime;

  BoxModel({
    this.id,
    required this.boxNumber,
    required this.isFavorite,
    required this.createdTime,
  });

  BoxModel copy({
    int? id,
    int? boxNumber,
    int? isFavorite,
    String? createdTime,
  }) =>
      BoxModel(
        id: id ?? this.id,
        boxNumber: boxNumber ?? this.boxNumber,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, dynamic> toJson() => {
        BoxFields.id: id,
        BoxFields.boxNumber: boxNumber,
        BoxFields.isFavorite: isFavorite,
        BoxFields.createdTime: createdTime,
      };

  static BoxModel fromJson(Map<String, dynamic> json) => BoxModel(
        id: json[BoxFields.id] as int?,
        boxNumber: json[BoxFields.boxNumber] as int,
        isFavorite: json[BoxFields.isFavorite] as int,
        createdTime: json[BoxFields.createdTime] as String,
      );
}
