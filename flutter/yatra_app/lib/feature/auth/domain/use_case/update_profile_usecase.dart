import 'package:dartz/dartz.dart';
import 'package:yatra_app/app/use_case/use_case.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class UpdateProfileUseCase implements UsecaseWithParams<void, UserEntity> {
  final IUserRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UserEntity user) {
    return _repository.updateProfile(user);
  }
}
