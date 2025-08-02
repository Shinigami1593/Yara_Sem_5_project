// lib/feature/trips/domain/usecase/get_trip_by_id_usecase.dart

import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';
import 'package:yatra_app/feature/trips/domain/repository/trip_repository.dart';

class GetTripByIdUseCase {
  final ITripRepository repository;

  GetTripByIdUseCase(this.repository);

  Future<TripEntity> call(String id) async {
    return await repository.getTripById(id);
  }
}
