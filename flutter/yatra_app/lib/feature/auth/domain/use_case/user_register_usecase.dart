import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yatra_app/app/use_case/use_case.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable{
  final String fullName;
  final String email;
  final String password;
  
  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.password
  });

  const RegisterUserParams.initial({
    required this.fullName,
    required this.email,
    required this.password
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    fullName,
    email,
    password
  ];
}


class UserRegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(name: params.fullName, email: params.email, password: params.password);

    return _userRepository.registerUser(userEntity);
  }
}
