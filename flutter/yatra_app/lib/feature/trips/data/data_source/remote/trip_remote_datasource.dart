import 'package:dio/dio.dart';
import 'package:yatra_app/app/constant/api_endpoints.dart';
import 'package:yatra_app/core/network/api_service.dart';
import 'package:yatra_app/feature/trips/data/data_source/trip_datasource.dart';
import 'package:yatra_app/feature/trips/data/model/trip_model.dart';
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';

class TripsRemoteDataSourceImpl implements ITripDataSource {
  final ApiService apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  TripsRemoteDataSourceImpl(this.apiService, this.tokenSharedPrefs);

  Future<Map<String, String>> _getAuthHeaders() async {
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => {},
      (token) {
        if (token != null && token.isNotEmpty) {
          return {'Authorization': 'Bearer $token'};
        }
        return {};
      },
    );
  }

  @override
  Future<List<TripModel>> getAllTrips({String? query}) async {
    final headers = await _getAuthHeaders();
    final response = await apiService.dio.get(
      ApiEndpoints.trips,
      queryParameters: {
        if (query != null && query.isNotEmpty) 'search': query,
      },
      options: Options(headers: headers),
    );

    final raw = response.data;
    print('Raw trips response: $raw');
    
    late List<dynamic> listData;
    if (raw is List) {
      listData = raw;
    } else if (raw is Map<String, dynamic>) {
      if (raw.containsKey('trips') && raw['trips'] is List) {
        listData = raw['trips'] as List<dynamic>;
      } else if (raw.containsKey('data') && raw['data'] is List) {
        listData = raw['data'] as List<dynamic>;
      } else if (raw.containsKey('trip') && raw['trip'] is List) {
        listData = raw['trip'] as List<dynamic>;
      } else {
        throw Exception('Unexpected trips response structure: $raw');
      }
    } else {
      throw Exception('Unexpected trips response type: ${raw.runtimeType}');
    }

    // Add debugging for each item
    final trips = <TripModel>[];
    for (int i = 0; i < listData.length; i++) {
      try {
        final item = listData[i];
        print('Processing trip $i: $item');
        
        // Check for null values in critical fields
        if (item is Map<String, dynamic>) {
          print('Trip $i - route: ${item['route']}');
          print('Trip $i - vehicle: ${item['vehicle']}');
          print('Trip $i - departureTime: ${item['departureTime']}');
          print('Trip $i - arrivalTime: ${item['arrivalTime']}');
          print('Trip $i - status: ${item['status']}');
        }
        
        final tripModel = TripModel.fromJson(item as Map<String, dynamic>);
        trips.add(tripModel);
      } catch (e) {
        print('Error parsing trip at index $i: $e');
        print('Trip data: ${listData[i]}');
        rethrow; // Re-throw to see the exact error
      }
    }

    return trips;
  }

  @override
  Future<TripModel> getTripById(String id) async {
    final headers = await _getAuthHeaders();
    final response = await apiService.dio.get(
      '${ApiEndpoints.trips}/$id',
      options: Options(headers: headers),
    );
    final raw = response.data;

    if (raw is Map<String, dynamic>) {
      if (raw.containsKey('trip') && raw['trip'] is Map<String, dynamic>) {
        return TripModel.fromJson(raw['trip'] as Map<String, dynamic>);
      }
      return TripModel.fromJson(raw);
    }

    throw Exception('Unexpected trip-by-id response format: $raw');
  }
}
