import 'package:yatra_app/feature/trips/data/data_source/trip_datasource.dart';
import 'package:yatra_app/feature/trips/domain/entity/trips_entity.dart';
import 'package:yatra_app/feature/trips/domain/repository/trip_repository.dart';

class TripsRepositoryImpl implements ITripRepository {
  final ITripDataSource remoteDataSource;

  TripsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TripEntity>> getAllTrips({String? query}) async {
    final tripModels = await remoteDataSource.getAllTrips(query: query);
    return tripModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TripEntity> getTripById(String id) async {
    final tripModel = await remoteDataSource.getTripById(id);
    return tripModel.toEntity();
  }
}
