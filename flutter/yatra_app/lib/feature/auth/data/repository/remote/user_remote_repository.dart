import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/data/data_source/remote/auth_remote_datasource.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository{
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({
    required UserRemoteDatasource userRemoteDatasource
  }) : _userRemoteDatasource = userRemoteDatasource;


  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async{
    try {
      final token = await _userRemoteDatasource.login(
        email,
        password,
      );
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async{
        try {
      await _userRemoteDatasource.register(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
}