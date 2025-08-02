import 'package:yatra_app/feature/trips/data/model/vehicle_model.dart';

abstract interface class IVehicleDataSource {
  Future<List<VehicleModel>> getAllVehicles();

  Future<VehicleModel> getVehicleById(String id);
}
