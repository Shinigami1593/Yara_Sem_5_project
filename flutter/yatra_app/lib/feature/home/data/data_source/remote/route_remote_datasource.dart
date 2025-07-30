// lib/feature/home/data/data_source/route_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';
import 'package:yatra_app/feature/home/data/data_source/route_datasource.dart';
import 'package:yatra_app/feature/home/data/model/route_model.dart';
import 'package:yatra_app/app/constant/api_endpoints.dart';
import 'package:yatra_app/core/network/api_service.dart';

class RouteRemoteDataSource implements IRouteDataSource {
  final ApiService apiService;
  final TokenSharedPrefs tokenSharedPrefs;

  RouteRemoteDataSource(this.apiService, this.tokenSharedPrefs);

  @override
  Future<List<RouteModel>> getAllRoutes() async {
    final tokenResult = await tokenSharedPrefs.getToken();

    // Handle failure or missing token
    final token = tokenResult.fold(
      (failure) => null,
      (token) => token,
    );

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await apiService.dio.get(
      ApiEndpoints.routes,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as List<dynamic>;
    return data.map((json) => RouteModel.fromJson(json)).toList();
  }


  @override
  Future<RouteModel> getRouteById(String id) async {
    final tokenResult = await tokenSharedPrefs.getToken();

    final token = tokenResult.fold(
      (failure) => null,
      (token) => token,
    );

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await apiService.dio.get(
      '${ApiEndpoints.routes}/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return RouteModel.fromJson(response.data);
  }

}
