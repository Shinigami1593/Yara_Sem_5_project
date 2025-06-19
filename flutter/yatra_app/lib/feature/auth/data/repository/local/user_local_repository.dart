import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/data/data_source/auth_datasource.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final IUserDataSource _userLocalDataSource;

  UserLocalRepository({
    required IUserDataSource userLocalDataSource,
  }) : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerStudent(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async {
    try {
      final result = await _userLocalDataSource.loginStudent(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageUrl = await _userLocalDataSource.uploadProfilePicture(file);
      return Right(imageUrl);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _userLocalDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
