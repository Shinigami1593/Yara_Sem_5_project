import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final BuildContext context;

  const GetProfileEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class UpdateProfileEvent extends ProfileEvent {
  final BuildContext context;
  final String name;
  final String firstName;
  final String lastName;
  final File? profilePicture; // Use File? for local file

  const UpdateProfileEvent({
    required this.context,
    required this.name,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [context, name, firstName, lastName, profilePicture];
}

class LogoutEvent extends ProfileEvent {
  final BuildContext context;

  const LogoutEvent({required this.context});

  @override
  List<Object?> get props => [context];
}