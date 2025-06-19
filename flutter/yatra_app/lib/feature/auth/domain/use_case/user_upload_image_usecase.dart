import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:yatra_app/app/use_case/use_case.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/repository/user_repository.dart';

class UserUploadImageUseCase implements UsecaseWithParams<String, File> {
  final IUserRepository _userRepository;

  UserUploadImageUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(File file) {
    return _userRepository.uploadProfilePicture(file);
  }
}
