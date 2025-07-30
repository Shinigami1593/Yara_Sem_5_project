// lib/feature/home/domain/usecase/get_all_routes_usecase.dart

import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';
import 'package:yatra_app/feature/home/domain/repository/route_repository.dart';

class GetAllRoutesUseCase {
  final IRouteRepository repository;

  GetAllRoutesUseCase(this.repository);

  Future<List<RouteEntity>> call() async {
    return await repository.getAllRoutes();
  }
}
