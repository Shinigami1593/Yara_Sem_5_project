import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase userLoginUseCase;

  LoginViewModel(this.userLoginUseCase) : super(LoginState.initial()) {
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await userLoginUseCase(
      LoginParams(email: event.username, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
        ));
      },
      (token) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          errorMessage: null,
        ));
      },
    );
  }
}
