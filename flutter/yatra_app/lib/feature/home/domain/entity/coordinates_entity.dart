// lib/feature/home/domain/entity/coordinate_entity.dart
import 'package:equatable/equatable.dart';

class CoordinateEntity extends Equatable {
  final double longitude;
  final double latitude;

  const CoordinateEntity({
    required this.longitude,
    required this.latitude,
  });

  @override
  List<Object?> get props => [longitude, latitude];
}
