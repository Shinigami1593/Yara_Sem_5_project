import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/core/common/snackbar/snackbar.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:yatra_app/feature/auth/presentation/view/signup_view.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:yatra_app/feature/home/presentation/view/dashboard_view.dart';
import 'package:yatra_app/feature/home/presentation/view_model/dashboard_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel(this._userLoginUseCase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToDashboardViewEvent>(_onNavigateToDashboardView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: serviceLocator<RegisterViewModel>(),
            child: const SignUpView(),
          ),
        ),
      );
    }
  }

  void _onNavigateToDashboardView(
    NavigateToDashboardViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: serviceLocator<DashboardViewModel>(),
            child: const DashboardView(),
          ),
        ),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUseCase(
      LoginParams(email: event.username, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(NavigateToDashboardViewEvent(context: event.context));
      },
    );
  }
}
