// lib/features/profile/presentation/bloc/profile_event.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch the current user's profile
class GetProfileEvent extends ProfileEvent {
  final BuildContext context;

  const GetProfileEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

// Event to update the user's profile
class UpdateProfileEvent extends ProfileEvent {
  final BuildContext context;
  final String name;
  final String firstName;
  final String lastName;
  final String? profilePicture; // Can be a file path or URL string

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