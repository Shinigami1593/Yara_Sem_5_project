// lib/feature/trips/domain/repository/vehicle_repository.dart
import 'package:yatra_app/feature/trips/domain/entity/vehicle_entity.dart';

abstract interface class IVehicleRepository {
  Future<List<VehicleEntity>> getAllVehicles();
  Future<VehicleEntity> getVehicleById(String id);
}
