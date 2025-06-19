import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yatra_app/app/use_case/use_case.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class LoginParams extends Equatable{
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
  
  const LoginParams.initial() : email = '', password = '';

  @override
  // TODO: implement props
  List<Object?> get props => [email,password];
}

class UserLoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository;

  UserLoginUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) {
    return _userRepository.loginUser(params.email, params.password);
  }
}
