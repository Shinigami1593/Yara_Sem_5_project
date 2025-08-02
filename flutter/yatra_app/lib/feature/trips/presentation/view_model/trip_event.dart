abstract class TripEvent {}

class FetchTripsEvent extends TripEvent {
  final String? query;
  FetchTripsEvent({this.query});
}

class FetchTripByIdEvent extends TripEvent {
  final String id;
  FetchTripByIdEvent(this.id);
}
