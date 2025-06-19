import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/core/common/snackbar/snackbar.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:yatra_app/feature/auth/presentation/view/signin_view.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUseCase _userRegisterUseCase;

  RegisterViewModel(this._userRegisterUseCase)
      : super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    // Field validation
    if (event.fullName.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty) {
      showMySnackBar(
        context: event.context,
        message: 'Please fill all fields.',
        color: Colors.red,
      );
      return;
    }

    // if (event.password != event.confirmPassword) {
    //   showMySnackBar(
    //     context: event.context,
    //     message: 'Passwords do not match.',
    //     color: Colors.red,
    //   );
    //   return;
    // }

    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUseCase(
        RegisterUserParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
        ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Registration failed. Please try again.',
          color: Colors.red,
        );
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        if (event.context.mounted) {
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
              builder: (_) => const SignInView(),
            ),
          );
        }
      },
    );
  }
}
