// lib/feature/home/data/data_source/route_datasource.dart
import 'package:yatra_app/feature/home/data/model/route_model.dart';

abstract interface class IRouteDataSource {
  Future<List<RouteModel>> getAllRoutes();
  Future<RouteModel> getRouteById(String id);
}
