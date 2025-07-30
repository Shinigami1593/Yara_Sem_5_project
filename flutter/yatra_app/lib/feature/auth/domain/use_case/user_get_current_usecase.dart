import 'package:dartz/dartz.dart';
import 'package:yatra_app/app/use_case/use_case.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';


class UserGetCurrentUseCase implements UsecaseWithoutParams<UserEntity> {
  final IUserRepository _userRepository;

  UserGetCurrentUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _userRepository.getCurrentUser();
  }
}
