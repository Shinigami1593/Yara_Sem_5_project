import 'dart:io';

import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerStudent(UserEntity studentData);

  Future<String> loginStudent(String username, String password);

  Future<String> uploadProfilePicture(File file);

  Future<UserEntity> getCurrentUser();
}

