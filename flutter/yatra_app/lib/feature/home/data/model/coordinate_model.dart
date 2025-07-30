// lib/feature/home/data/model/coordinate_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:yatra_app/feature/home/domain/entity/coordinates_entity.dart';

part 'coordinate_model.g.dart';

@JsonSerializable()
class CoordinateModel {
  final double longitude;
  final double latitude;

  CoordinateModel({
    required this.longitude,
    required this.latitude,
  });

  factory CoordinateModel.fromJson(Map<String, dynamic> json) =>
      _$CoordinateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateModelToJson(this);

  CoordinateEntity toEntity() => CoordinateEntity(
        longitude: longitude,
        latitude: latitude,
      );

  static CoordinateModel fromEntity(CoordinateEntity entity) => CoordinateModel(
        longitude: entity.longitude,
        latitude: entity.latitude,
      );
}
