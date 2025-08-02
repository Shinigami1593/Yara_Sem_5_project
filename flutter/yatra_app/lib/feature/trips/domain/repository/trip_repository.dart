import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';

abstract interface class ITripRepository {
  Future<List<TripEntity>> getAllTrips({String? query});
  Future<TripEntity> getTripById(String id);
}
