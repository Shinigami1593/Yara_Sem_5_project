// lib/feature/home/domain/entity/route_entity.dart
import 'package:equatable/equatable.dart';
import 'package:yatra_app/feature/home/domain/entity/coordinates_entity.dart';

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String source;
  final String destination;
  final List<CoordinateEntity> points;
  final String? type;    // bus, micro, tempo, optional
  final String status;   // active, inactive
  final String userId;

  const RouteEntity({
    required this.id,
    required this.name,
    required this.source,
    required this.destination,
    required this.points,
    this.type,
    this.status = 'active',
    required this.userId,
  });

  @override
  List<Object?> get props =>
      [id, name, source, destination, points, type, status, userId];
}
