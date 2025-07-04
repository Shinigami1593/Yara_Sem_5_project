import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yatra_app/app/use_case/use_case.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

/// Params for registration: full name, email, password
class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

/// Use Case class for registering a user
class UserRegisterUseCase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final fullName = params.fullName.trim();
    final nameParts = fullName.split(' ');

    final firstName = nameParts.first;
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    final userEntity = UserEntity(
      name: fullName,
      email: params.email,
      password: params.password,
      firstName: firstName,
      lastName: lastName,
    );

    return _userRepository.registerUser(userEntity);
  }
}
