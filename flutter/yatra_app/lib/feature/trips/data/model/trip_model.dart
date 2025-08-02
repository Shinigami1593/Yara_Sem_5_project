// lib/feature/trips/data/model/trip_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:yatra_app/feature/home/data/model/route_model.dart';
import 'package:yatra_app/feature/trips/data/model/vehicle_model.dart';
import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';

part 'trip_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TripModel {
  @JsonKey(name: '_id')
  final String id;
  final RouteModel route;
  final VehicleModel vehicle;

  @JsonKey(defaultValue: '')
  final String departureTime; // "HH:MM"

  @JsonKey(defaultValue: '')
  final String arrivalTime; // "HH:MM"

  @JsonKey(defaultValue: 'scheduled')
  final String status; // scheduled, cancelled, completed

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.route,
    required this.vehicle,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
    required this.createdAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    // normalize naming and provide fallback
    final normalized = {
      ...json,
      'departureTime': json['departureTime'] ?? json['departure_time'] ?? '',
      'arrivalTime': json['arrivalTime'] ?? json['arrival_time'] ?? '',
      'status': json['status'] ?? 'scheduled',
      'createdAt': json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String(),
    };

    return _$TripModelFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$TripModelToJson(this);

  TripEntity toEntity() => TripEntity(
        id: id,
        route: route.toEntity(),
        vehicle: vehicle.toEntity(),
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        status: status,
        createdAt: createdAt,
      );

  static TripModel fromEntity(TripEntity entity) => TripModel(
        id: entity.id,
        route: RouteModel.fromEntity(entity.route),
        vehicle: VehicleModel.fromEntity(entity.vehicle),
        departureTime: entity.departureTime,
        arrivalTime: entity.arrivalTime,
        status: entity.status,
        createdAt: entity.createdAt,
      );

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
}
