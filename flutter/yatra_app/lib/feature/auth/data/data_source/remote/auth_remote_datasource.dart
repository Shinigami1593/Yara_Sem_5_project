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
  Future<UserEntity> getCurrentUser() async{
    try{
      final response = await _apiService.dio.get(ApiEndpoints.getProfile);
      if(response.statusCode == 200){
        final userApiModel = UserApiModel.fromJson(response.data);
        return userApiModel.toEntity();
      }else{
        throw Exception('Failed to fetch user: ${response.statusMessage}');
      }
    }on DioException catch(e){
      throw Exception('Failed to fetch user: ${e.error}');
    }catch(e){
      throw Exception('Failed to get user: $e');
    }
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
  Future<String> uploadProfilePicture(File file) async{
    try { 
      final formData = FormData.fromMap({ 'profilePicture': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last), }); 
      final response = await _apiService.dio.put( ApiEndpoints.getProfile, data: formData, ); 
      if (response.statusCode == 200) { 
        final userApiModel = UserApiModel.fromJson(response.data['user']); 
        return userApiModel.profilePicture ?? ''; 
      } else { 
        throw Exception('Failed to upload profile picture: ${response.statusMessage}'); 
      } 
    } on DioException catch (e) { 
      throw Exception('Failed to upload profile picture: ${e.error}'); 
    } catch (e) { 
      throw Exception('Failed to upload profile picture: $e'); 
    } 
  }
}
