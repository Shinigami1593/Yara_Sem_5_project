// lib/feature/home/presentation/view_model/route_viewmodel.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yatra_app/core/network/ors_service.dart';
import 'package:yatra_app/feature/home/domain/use_case/get_all_routes_usecase.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_event.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_state.dart';

class RouteViewModel extends Bloc<RouteEvent, RouteState> {
  final GetAllRoutesUseCase getAllRoutesUseCase;

  RouteViewModel(this.getAllRoutesUseCase) : super(RouteInitial()) {
    on<FetchRoutesWithInputEvent>(_onFetchRoutes);
  }

  Future<void> _onFetchRoutes(
    FetchRoutesWithInputEvent event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());

    try {
      final routes = await getAllRoutesUseCase();

      if (routes.isNotEmpty) {
        emit(RouteLoaded(routes));
        return;
      }

      // 🧭 Use Geolocator to get user's current location
      final position = await determinePosition();
      final sourceCoords = [position.longitude, position.latitude];

      // Example: Destination is Koteshwor (you may allow user to input this later)
      final destinationCoords = [85.3470, 27.6789];

      final fallbackRoute = await ORSService().fetchRouteFromORS(
        sourceName: "Your Location",
        destinationName: "Koteshwor",
        sourceCoords: sourceCoords,
        destinationCoords: destinationCoords,
      );

      emit(RouteLoaded([fallbackRoute.toEntity()]));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }

  // 🔐 Get permission and location
  Future<Position> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permission denied.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
