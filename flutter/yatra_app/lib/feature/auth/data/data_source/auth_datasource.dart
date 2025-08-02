import 'dart:io';

import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> register(UserEntity studentData);

  Future<String> login(String email, String password);

  Future<String> uploadProfilePicture(File file);

  Future<UserEntity> getCurrentUser();

  Future<void> updateProfile(UserEntity updatedUser);

  Future<void> logout();
}

