import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  /// Register a new user
  Future<Either<Failure, void>> registerUser(UserEntity user);

  /// Log in and return token
  Future<Either<Failure, String>> loginUser(String email, String password);

  /// Upload profile picture and return its URL/path
  Future<Either<Failure, String>> uploadProfilePicture(File file);

  /// Get the current logged-in user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Update the user's profile
  Future<Either<Failure, void>> updateProfile(UserEntity updatedUser);

  //logoutUSer
  // Future<Either<Failure,void>> logoutUser();
}
