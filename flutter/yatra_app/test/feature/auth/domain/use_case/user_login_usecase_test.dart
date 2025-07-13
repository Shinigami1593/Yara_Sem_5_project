import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_login_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockUserRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late UserLoginUseCase usecase;

  setUp(() {
    repository = MockUserRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = UserLoginUseCase(userRepository: repository, tokenSharedPrefs: tokenSharedPrefs);
  });

  //when user adds valid email and password
  test(
    'should call the [UserRepo.loginUser] with correct email and password (ayush@gmail.com, ayush123)', 
    () async {
      when(() => repository.loginUser(any(), any())).thenAnswer((invocation) async{
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if(email == 'ayush@gmail.com' && password == 'ayush123'){
          return Future.value(const Right('token'));
        }else {
          return Future.value(
            const Left(AuthFailure(message: 'Invalid username or password'))
          );
        }
      });

      when(() => tokenSharedPrefs.saveToken(any())).thenAnswer((_) async => Right(null));

      final result = await usecase(LoginParams(email: 'ayush@gmail.com', password: 'ayush123'));

      expect(result, const Right('token'));

      verify(() => repository.loginUser(any(), any())).called(1);
      verify(() => tokenSharedPrefs.saveToken(any())).called(1);

      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(tokenSharedPrefs);

      // tearDown(() {
      //   reset(repository);
      //   reset(tokenSharedPrefs);
      // });
  });

  //when user give invalid credentials:
  test('should return AuthFailure when credentials are incorrect', () async {
  when(() => repository.loginUser(any(), any())).thenAnswer(
    (_) async => const Left(AuthFailure(message: 'Invalid username or password')),
  );

  final result = await usecase(LoginParams(email: 'wrong@mail.com', password: 'wrongpass'));

  expect(result, const Left(AuthFailure(message: 'Invalid username or password')));

  verify(() => repository.loginUser(any(), any())).called(1);
  verifyNever(() => tokenSharedPrefs.saveToken(any()));

  verifyNoMoreInteractions(repository);
  verifyNoMoreInteractions(tokenSharedPrefs);
});
}
