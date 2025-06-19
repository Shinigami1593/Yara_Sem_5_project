import 'package:flutter/material.dart';

sealed class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String password;

  RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.password,
  });
}
