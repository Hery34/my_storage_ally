import 'package:my_storage_ally/database/box_fields.dart';

class BoxModel {
  late final int? idBox;
  final String boxNumber;
  final String boxDescription;
  final bool isFavorite;
  final DateTime? createdTime;

  BoxModel({
    this.idBox,
    required this.boxNumber,
    this.boxDescription = '',
    this.isFavorite = false,
    this.createdTime,
  });

  BoxModel copy({
    int? idBox,
    String? boxNumber,
    String? boxDescription,
    bool? isFavorite,
    DateTime? createdTime,
  }) =>
      BoxModel(
        idBox: idBox ?? this.idBox,
        boxNumber: boxNumber ?? this.boxNumber,
        boxDescription: boxDescription ?? this.boxDescription,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, Object?> toJson() => {
        BoxFields.id: idBox,
        BoxFields.boxNumber: boxNumber,
        BoxFields.boxDescription: boxDescription,
        BoxFields.isFavorite: isFavorite ? 1 : 0,
        BoxFields.createdTime: createdTime?.toIso8601String(),
      };

  factory BoxModel.fromJson(Map<String, Object?> json) => BoxModel(
        idBox: json[BoxFields.id] as int?,
        boxNumber: json[BoxFields.boxNumber] as String,
        boxDescription: json[BoxFields.boxDescription] as String? ?? '',
        isFavorite: json[BoxFields.isFavorite] == 1,
        createdTime:
            DateTime.tryParse(json[BoxFields.createdTime] as String? ?? ''),
      );
}
