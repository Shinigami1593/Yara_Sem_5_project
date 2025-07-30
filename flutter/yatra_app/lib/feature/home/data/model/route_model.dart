// lib/feature/home/data/model/route_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:yatra_app/feature/home/data/model/coordinate_model.dart';
import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';

part 'route_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RouteModel {
  final String id;
  final String name;
  final String source;
  final String destination;
  final List<CoordinateModel> points;
  final String? type;
  final String status;
  final String userId;

  RouteModel({
    required this.id,
    required this.name,
    required this.source,
    required this.destination,
    required this.points,
    this.type,
    required this.status,
    required this.userId,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);

  RouteEntity toEntity() => RouteEntity(
        id: id,
        name: name,
        source: source,
        destination: destination,
        points: points.map((c) => c.toEntity()).toList(),
        type: type,
        status: status,
        userId: userId,
      );

  static RouteModel fromEntity(RouteEntity entity) => RouteModel(
        id: entity.id,
        name: entity.name,
        source: entity.source,
        destination: entity.destination,
        points: entity.points.map((c) => CoordinateModel.fromEntity(c)).toList(),
        type: entity.type,
        status: entity.status,
        userId: entity.userId,
      );
}
