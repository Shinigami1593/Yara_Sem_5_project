import 'package:dartz/dartz.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class UserLogoutUseCase {
  final IUserRepository repository;

  UserLogoutUseCase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.logoutUser();
  }
}