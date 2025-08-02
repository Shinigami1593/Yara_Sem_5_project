import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Shared / core
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';
import 'package:yatra_app/core/network/api_service.dart';
import 'package:yatra_app/core/network/hive_service.dart';

// Auth
import 'package:yatra_app/feature/auth/data/data_source/local/auth_local_datasource.dart';
import 'package:yatra_app/feature/auth/data/data_source/remote/auth_remote_datasource.dart';
import 'package:yatra_app/feature/auth/data/repository/local/user_local_repository.dart';
import 'package:yatra_app/feature/auth/data/repository/remote/user_remote_repository.dart';
import 'package:yatra_app/feature/auth/domain/use_case/update_profile_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_upload_image_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_logout_usecase.dart'; // Add import for UserLogoutUseCase
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Home / Routes
import 'package:yatra_app/feature/home/data/data_source/route_datasource.dart';
import 'package:yatra_app/feature/home/data/data_source/remote/route_remote_datasource.dart';
import 'package:yatra_app/feature/home/data/repository/remote/route_remote_repository.dart';
import 'package:yatra_app/feature/home/domain/repository/route_repository.dart';
import 'package:yatra_app/feature/home/domain/use_case/get_all_routes_usecase.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_viewmodel.dart';

// Trips & Vehicles
import 'package:yatra_app/feature/trips/data/data_source/trip_datasource.dart';
import 'package:yatra_app/feature/trips/data/data_source/remote/trip_remote_datasource.dart';
import 'package:yatra_app/feature/trips/data/repository/remote/trip_remote_repository.dart';
import 'package:yatra_app/feature/trips/domain/repository/trip_repository.dart';
import 'package:yatra_app/feature/trips/domain/use_case/get_all_trips_usecase.dart';
import 'package:yatra_app/feature/trips/domain/use_case/get_trip_by_is_usecase.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_view_model.dart';


// Splash
import 'package:yatra_app/feature/splash/presentation/view_model/splash_screen_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initProfileModule();
  await _initHomeModule();
  await _initTripsModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initSharedPrefs() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory(
    () => UserRemoteDatasource(
      apiService: serviceLocator<ApiService>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(userLocalDataSource: serviceLocator<UserLocalDataSource>()),
  );
  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUseCase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserUploadImageUseCase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUseCase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserLogoutUseCase(repository: serviceLocator<UserRemoteRepository>()), // Register UserLogoutUseCase
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      serviceLocator<UserRegisterUseCase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
  );
}

Future<void> _initProfileModule() async {
  serviceLocator.registerFactory(
    () => UpdateProfileUseCase(serviceLocator<UserRemoteRepository>()),
  );
  serviceLocator.registerFactory(
    () => ProfileViewModel(
      getCurrentUser: serviceLocator<UserGetCurrentUseCase>(),
      updateProfile: serviceLocator<UpdateProfileUseCase>(),
      userLogout: serviceLocator<UserLogoutUseCase>(), // Pass UserLogoutUseCase instead of null
    ),
  );
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory<IRouteDataSource>(
    () => RouteRemoteDataSource(
      serviceLocator<ApiService>(),
      serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory<IRouteRepository>(
    () => RouteRemoteRepository(serviceLocator<IRouteDataSource>()),
  );

  serviceLocator.registerFactory<GetAllRoutesUseCase>(
    () => GetAllRoutesUseCase(serviceLocator<IRouteRepository>()),
  );

  serviceLocator.registerFactory<RouteViewModel>(
    () => RouteViewModel(serviceLocator<GetAllRoutesUseCase>()),
  );
}

Future<void> _initTripsModule() async {
  serviceLocator.registerFactory<ITripDataSource>(
    () => TripsRemoteDataSourceImpl(
      serviceLocator<ApiService>(),
      serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory<ITripRepository>(
    () => TripsRepositoryImpl(serviceLocator<ITripDataSource>()),
  );

  serviceLocator.registerFactory<GetAllTripsUseCase>(
    () => GetAllTripsUseCase(serviceLocator<ITripRepository>()),
  );

  serviceLocator.registerFactory<GetTripByIdUseCase>(
    () => GetTripByIdUseCase(serviceLocator<ITripRepository>()),
  );

  serviceLocator.registerFactory<TripViewModel>(
    () => TripViewModel(
      getAllTripsUseCase: serviceLocator<GetAllTripsUseCase>(),
      getTripByIdUseCase: serviceLocator<GetTripByIdUseCase>(),
    ),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}