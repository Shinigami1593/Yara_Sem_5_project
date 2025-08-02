// lib/feature/trips/data/data_source/remote/vehicle_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:yatra_app/core/network/api_service.dart';
import 'package:yatra_app/feature/trips/data/data_source/vehicle_datasource.dart';
import 'package:yatra_app/feature/trips/data/model/vehicle_model.dart';
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';

class VehicleRemoteDataSource implements IVehicleDataSource {
  final ApiService apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  VehicleRemoteDataSource({
    required this.apiService,
    required this.tokenSharedPrefs,
  });

  Future<String> _getTokenOrThrow() async {
    final result = await tokenSharedPrefs.getToken();
    return result.fold(
      (failure) => throw Exception('Failed to get token: ${failure.toString()}'),
      (token) => token ?? (throw Exception('No token stored')),
    );
  }

  Options _withAuthHeader(String token) {
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    final token = await _getTokenOrThrow();
    final response = await apiService.dio.get(
      "vehicle", // adjust if your endpoint differs
      options: _withAuthHeader(token),
    );
    final data = response.data['vehicles'] ?? response.data;
    if (data is List) {
      return data.map((e) => VehicleModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Unexpected response format for vehicles');
  }

  @override
  Future<VehicleModel> getVehicleById(String id) async {
    final token = await _getTokenOrThrow();
    final response = await apiService.dio.get(
      "vehicle/$id", // adjust if your route differs
      options: _withAuthHeader(token),
    );
    return VehicleModel.fromJson(response.data);
  }
}
