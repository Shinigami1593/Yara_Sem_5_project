// lib/features/profile/presentation/bloc/profile_state.dart

import 'package:equatable/equatable.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final UserEntity? user;
  final String? errorMessage;
  final bool isLoggedOut;

  const ProfileState({
    required this.isLoading,
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.isLoggedOut = false
  });

  // Initial state when the feature is first loaded
  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: false,
      isSuccess: false,
      user: null,
      errorMessage: null,
      isLoggedOut: false
    );
  }

  // Helper method to create a copy of the state with new values
  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    UserEntity? user,
    String? errorMessage,
    bool? isLoggedOut
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, user, errorMessage,isLoggedOut];
}