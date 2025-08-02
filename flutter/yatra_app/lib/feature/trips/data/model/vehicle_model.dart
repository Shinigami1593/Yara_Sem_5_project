// lib/feature/trips/data/model/vehicle_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:yatra_app/feature/trips/domain/entity/vehicle_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(defaultValue: 'Bus')
  final String type; // Bus, Micro, Tempo

  VehicleModel({
    required this.id,
    required this.type,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'] as String? ?? '',
      type: json['type'] as String? ?? 'Bus',
    );
  }

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  VehicleEntity toEntity() => VehicleEntity(
        id: id,
        type: type,
      );

  static VehicleModel fromEntity(VehicleEntity entity) => VehicleModel(
        id: entity.id,
        type: entity.type,
      );
}
