import 'dart:io';

import 'package:yatra_app/feature/auth/data/data_source/auth_datasource.dart';
import 'package:yatra_app/feature/auth/data/model/auth_hive_model.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/core/network/hive_service.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService}) : _hiveService = hiveService;

  @override
  Future<void> registerStudent(UserEntity studentData) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(studentData);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<String> loginStudent(String username, String password) async {
    try {
      final userHiveModel = await _hiveService.login(username, password);
      if (userHiveModel != null && userHiveModel.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // Since this is local Hive datasource and file upload likely requires backend or storage service,
    // leave this unimplemented or handle accordingly if you want to store path locally
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final userHiveModel = await _hiveService.getCurrentUser();
      if (userHiveModel != null) {
        return userHiveModel.toEntity();
      } else {
        throw Exception("No current user found");
      }
    } catch (e) {
      throw Exception("Failed to get current user: $e");
    }
  }
}
