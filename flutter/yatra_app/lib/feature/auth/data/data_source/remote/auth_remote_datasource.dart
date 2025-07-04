import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yatra_app/app/constant/api_endpoints.dart';
import 'package:yatra_app/core/network/api_service.dart';
import 'package:yatra_app/feature/auth/data/data_source/auth_datasource.dart';
import 'package:yatra_app/feature/auth/data/model/auth_api_model.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource{
  final ApiService _apiService;
  UserRemoteDatasource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<UserEntity> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<String> login(String email, String password) async{
    try{
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email' : email, 'password':password},
      );
      if(response.statusCode == 200){
        final str = response.data['token'];
        return str;
      }else{
        throw Exception(response.statusMessage);
      }
    }on DioException catch(e){
      throw Exception('Failed to login: ${e.message}');
    }catch(e){
      throw Exception('Failed to login : $e');
    }
  }

  @override
  Future<void> register(UserEntity studentData) async{
      try {
      final userApiModel = UserApiModel.fromEntity(studentData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(
          'Failed to register: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
}
