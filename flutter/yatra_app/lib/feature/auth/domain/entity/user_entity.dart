
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? role;
  final DateTime? createdAt;
  final String? profilePicture; // Optional, added after login

  const UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.role,
    this.createdAt,
    this.profilePicture,
  });
              
  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    password,
    firstName,
    lastName,
    role,
    createdAt,
    profilePicture,
  ];
}