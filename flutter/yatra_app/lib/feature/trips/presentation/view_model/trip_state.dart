import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<TripEntity> trips;
  TripLoaded(this.trips);
}

class TripByIdLoaded extends TripState {
  final TripEntity trip;
  TripByIdLoaded(this.trip);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}
