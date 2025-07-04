import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';
import 'package:yatra_app/core/network/api_service.dart';
import 'package:yatra_app/core/network/hive_service.dart';
import 'package:yatra_app/feature/auth/data/data_source/auth_datasource.dart';
import 'package:yatra_app/feature/auth/data/data_source/local/auth_local_datasource.dart';
import 'package:yatra_app/feature/auth/data/data_source/remote/auth_remote_datasource.dart';
import 'package:yatra_app/feature/auth/data/repository/local/user_local_repository.dart';
import 'package:yatra_app/feature/auth/data/repository/remote/user_remote_repository.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_upload_image_usecase.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:yatra_app/feature/home/presentation/view_model/dashboard_view_model.dart';
import 'package:yatra_app/feature/splash/presentation/view_model/splash_screen_view_model.dart';

final serviceLocator = GetIt.instance;


Future<void> initDependencies() async {
  await _initHiveService();
  await _initAuthModule();
  await _initApiService();
  await _initSharedPrefs();
  await _initSplashModule();
  await _initHomeModule();
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

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}


Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => DashboardViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(userLocalDataSource: serviceLocator<UserLocalDataSource>()),
  );
  serviceLocator.registerFactory(
    () => UserRemoteRepository(userRemoteDatasource: serviceLocator<UserRemoteDatasource>()),
  );

  serviceLocator.registerFactory(
    () => UserLoginUseCase(userRepository: serviceLocator<UserRemoteRepository>(), tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
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
    () => RegisterViewModel(
      serviceLocator<UserRegisterUseCase>(),
      // serviceLocator<UserUploadImageUseCase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}