// lib/feature/trips/domain/entity/vehicle_entity.dart
import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String id;
  final String type; // Bus, Micro, Tempo

  const VehicleEntity({
    required this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}
