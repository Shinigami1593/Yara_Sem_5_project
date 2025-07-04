
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? image; // Optional, added after login

  const UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    password,
    firstName,
    lastName,
    image,
  ];
}