import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  /// Registers a new user (no profile picture yet)
  Future<Either<Failure, void>> registerUser(UserEntity user);

  /// Logs in user using email and password
  Future<Either<Failure, String>> loginUser(String email, String password);

  /// Uploads profile picture after login
  Future<Either<Failure, String>> uploadProfilePicture(File file);

  /// Gets the current logged-in user's data
  Future<Either<Failure, UserEntity>> getCurrentUser();
}