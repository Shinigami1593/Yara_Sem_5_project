import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yatra_app/app/constant/api_endpoints.dart';
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';
import 'package:yatra_app/core/network/api_service.dart';
import 'package:yatra_app/feature/auth/data/data_source/auth_datasource.dart';
import 'package:yatra_app/feature/auth/data/model/auth_api_model.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserRemoteDatasource({
    required ApiService apiService,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _apiService = apiService,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final result = await _tokenSharedPrefs.getToken(); // returns Either<Failure, String>

      final token = result.fold(
        (failure) => throw Exception('Token retrieval failed: $failure'),
        (value) => value,
      );

      final response = await _apiService.dio.get(
        ApiEndpoints.getProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userApiModel = UserApiModel.fromJson(response.data);
        return userApiModel.toEntity();
      } else {
        throw Exception('Failed to fetch user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }


  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<void> register(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      final result = await _tokenSharedPrefs.getToken(); // Either<Failure, String>

      final token = result.fold(
        (failure) => throw Exception('Token retrieval failed: $failure'),
        (value) => value,
      );

      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _apiService.dio.put(
        ApiEndpoints.getProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userApiModel = UserApiModel.fromJson(response.data['user']);
        return userApiModel.profilePicture ?? '';
      } else {
        throw Exception(
          'Failed to upload profile picture: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload profile picture: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }


 @override
  Future<void> updateProfile(UserEntity updatedUser) async {
    try {
      final result = await _tokenSharedPrefs.getToken(); // Either<Failure, String>

      final token = result.fold(
        (failure) => throw Exception('Token retrieval failed: $failure'),
        (value) => value,
      );

      final Map<String, dynamic> formDataMap = {
        'name': updatedUser.name,
        'firstName': updatedUser.firstName,
        'lastName': updatedUser.lastName,
      };

      if (updatedUser.profilePicture != null &&
          File(updatedUser.profilePicture!).existsSync()) {
        formDataMap['profilePicture'] = await MultipartFile.fromFile(
          updatedUser.profilePicture!,
          filename: updatedUser.profilePicture!.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _apiService.dio.put(
        ApiEndpoints.getProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

}
