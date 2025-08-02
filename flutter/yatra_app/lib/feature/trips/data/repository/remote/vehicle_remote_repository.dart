// lib/feature/trips/data/repository/vehicle_repository_impl.dart
import 'package:yatra_app/feature/trips/domain/repository/vehicle_repository.dart';
import 'package:yatra_app/feature/trips/domain/entity/vehicle_entity.dart';
import 'package:yatra_app/feature/trips/data/data_source/vehicle_datasource.dart';

class VehicleRepositoryImpl implements IVehicleRepository {
  final IVehicleDataSource remoteDataSource;

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VehicleEntity>> getAllVehicles() async {
    final models = await remoteDataSource.getAllVehicles();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<VehicleEntity> getVehicleById(String id) async {
    final model = await remoteDataSource.getVehicleById(id);
    return model.toEntity();
  }
}
