import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/feature/trips/domain/use_case/get_all_trips_usecase.dart';
import 'package:yatra_app/feature/trips/domain/use_case/get_trip_by_is_usecase.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_state.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_event.dart';

class TripViewModel extends Bloc<TripEvent, TripState> {
  final GetAllTripsUseCase getAllTripsUseCase;
  final GetTripByIdUseCase getTripByIdUseCase;

  TripViewModel({
    required this.getAllTripsUseCase,
    required this.getTripByIdUseCase,
  }) : super(TripInitial()) {
    on<FetchTripsEvent>(_onFetchTrips);
    on<FetchTripByIdEvent>(_onFetchTripById);
  }

  Future<void> _onFetchTrips(
    FetchTripsEvent event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    try {
      final trips = await getAllTripsUseCase.call(query: event.query);
      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }

  Future<void> _onFetchTripById(
    FetchTripByIdEvent event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    try {
      final trip = await getTripByIdUseCase.call(event.id);
      emit(TripByIdLoaded(trip));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }
}
