// lib/feature/trips/domain/entity/trip_entity.dart
import 'package:equatable/equatable.dart';
import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';
import 'package:yatra_app/feature/trips/domain/entity/vehicle_entity.dart';

class TripEntity extends Equatable {
  final String id;
  final RouteEntity route;
  final VehicleEntity vehicle;
  final String departureTime; // "HH:MM"
  final String arrivalTime; // "HH:MM"
  final String status; // scheduled, cancelled, completed
  final DateTime createdAt;

  const TripEntity({
    required this.id,
    required this.route,
    required this.vehicle,
    required this.departureTime,
    required this.arrivalTime,
    this.status = 'scheduled',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        route,
        vehicle,
        departureTime,
        arrivalTime,
        status,
        createdAt,
      ];
}
