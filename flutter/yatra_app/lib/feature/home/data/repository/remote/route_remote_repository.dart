// lib/feature/home/data/repository/route_remote_repository.dart
import 'package:yatra_app/feature/home/data/data_source/route_datasource.dart';
import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';
import 'package:yatra_app/feature/home/domain/repository/route_repository.dart';

class RouteRemoteRepository implements IRouteRepository {
  final IRouteDataSource dataSource;

  RouteRemoteRepository(this.dataSource);

  @override
  Future<List<RouteEntity>> getAllRoutes() async {
    final models = await dataSource.getAllRoutes();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<RouteEntity> getRouteById(String id) async {
    final model = await dataSource.getRouteById(id);
    return model.toEntity();
  }
}
