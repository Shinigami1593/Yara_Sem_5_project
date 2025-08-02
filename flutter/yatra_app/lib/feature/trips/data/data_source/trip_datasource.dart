import 'package:yatra_app/feature/trips/data/model/trip_model.dart';

abstract interface class ITripDataSource {
  /// Fetch all trips, optionally filtered by a search query (e.g., route name, status).
  Future<List<TripModel>> getAllTrips({String? query});

  /// Fetch a single trip by its ID.
  Future<TripModel> getTripById(String id);
}
