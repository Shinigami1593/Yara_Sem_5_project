import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yatra_app/core/error/failure.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';

// Mock classes
class MockUserLoginUseCase extends Mock implements UserLoginUseCase {}
class FakeLoginParams extends Fake implements LoginParams {}
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockUserLoginUseCase mockLoginUseCase;
  late MockBuildContext mockContext;

  const email = 'test@email.com';
  const password = '12345678';
  const token = 'mock_token';

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockLoginUseCase = MockUserLoginUseCase();
    mockContext = MockBuildContext();

    // If your code accesses context.mounted (e.g. to call Navigator), mock it
    when(() => mockContext.mounted).thenReturn(true);
  });

  group('LoginViewModel', () {
    blocTest<LoginViewModel, LoginState>(
      'emits loading and success when login succeeds',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Right(token));
        return LoginViewModel(mockLoginUseCase);
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: email,
          password: password,
          context: mockContext,
        ),
      ),
      expect: () => [
        LoginState.initial().copyWith(isLoading: true),
        LoginState.initial().copyWith(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(LoginParams(email: email, password: password))).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits loading and failure with error message when login fails',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async =>
                const Left(RemoteDatabaseFailure(message: 'Invalid credentials')));
        return LoginViewModel(mockLoginUseCase);
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: email,
          password: password,
          context: mockContext,
        ),
      ),
      expect: () => [
        LoginState.initial().copyWith(isLoading: true),
        LoginState.initial().copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Invalid credentials'
        )
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(LoginParams(email: email, password: password,))).called(1);
      },
    );
  });
}
