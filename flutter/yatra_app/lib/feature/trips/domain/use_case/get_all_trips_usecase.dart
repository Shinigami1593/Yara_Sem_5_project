// lib/feature/trips/domain/usecase/get_all_trips_usecase.dart

import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';
import 'package:yatra_app/feature/trips/domain/repository/trip_repository.dart';

class GetAllTripsUseCase {
  final ITripRepository repository;

  GetAllTripsUseCase(this.repository);

  Future<List<TripEntity>> call({String? query}) async {
    return await repository.getAllTrips(query: query);
  }
}
