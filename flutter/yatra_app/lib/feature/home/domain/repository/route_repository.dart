// lib/feature/home/domain/repository/route_repository.dart
import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';

abstract interface class IRouteRepository {
  Future<List<RouteEntity>> getAllRoutes();
  Future<RouteEntity> getRouteById(String id);
}
