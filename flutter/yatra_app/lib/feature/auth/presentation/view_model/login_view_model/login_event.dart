import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent{}

class NavigateToRegisterViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToRegisterViewEvent({required this.context});
}

class NavigateToDashboardViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToDashboardViewEvent({required this.context});
}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final BuildContext context;
  final String username;
  final String password;

  LoginWithEmailAndPasswordEvent({
    required this.context,
    required this.username,
    required this.password,
  });
}
