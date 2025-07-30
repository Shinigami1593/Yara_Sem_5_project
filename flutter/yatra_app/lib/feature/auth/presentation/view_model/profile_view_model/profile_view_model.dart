// lib/features/profile/presentation/bloc/profile_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/app/shared_pref/token_shared_pref.dart';
import 'package:yatra_app/core/common/snackbar/snackbar.dart';
import 'package:yatra_app/feature/auth/domain/entity/user_entity.dart';
import 'package:yatra_app/feature/auth/domain/use_case/update_profile_usecase.dart';
import 'package:yatra_app/feature/auth/domain/use_case/user_get_current_usecase.dart';
// import 'package:yatra_app/feature/auth/domain/use_case/user_logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final UserGetCurrentUseCase _getCurrentUser;
  final UpdateProfileUseCase _updateProfile;
  // final UserLogoutUseCase _userLogout;

  ProfileViewModel({
    required UserGetCurrentUseCase getCurrentUser,
    required UpdateProfileUseCase updateProfile,
    // required UserLogoutUseCase userLogout
  })  : _getCurrentUser = getCurrentUser,
        _updateProfile = updateProfile,
        // _userLogout = userLogout,
        super(ProfileState.initial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result = await _getCurrentUser();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
        showMySnackBar(context: event.context, message: failure.message, color: Colors.red);
      },
      (user) {
        emit(state.copyWith(isLoading: false, isSuccess: true, user: user));
      },
    );
  }

  Future<void> _onUpdateProfile(
  UpdateProfileEvent event,
  Emitter<ProfileState> emit,
  ) async {
    if (event.name.isEmpty || event.firstName.isEmpty || event.lastName.isEmpty) {
      showMySnackBar(context: event.context, message: 'Please fill all required fields.', color: Colors.red);
      return;
    }

    emit(state.copyWith(isLoading: true, isSuccess: false));

    final result = await _updateProfile(UserEntity(
      name: event.name,
      firstName: event.firstName,
      lastName: event.lastName,
      profilePicture: event.profilePicture, email: '', password: '',
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
        showMySnackBar(context: event.context, message: failure.message, color: Colors.red);
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(context: event.context, message: 'Profile updated successfully', color: Colors.green);

        // Optionally refresh updated profile
        add(GetProfileEvent(context: event.context));
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  )async{
    final result = await serviceLocator<TokenSharedPrefs>().saveToken("");

    result.fold(
      (failure){
        showMySnackBar(context: event.context, message: failure.message, color: Colors.red);
      },
      (_){
        emit(state.copyWith(isLoggedOut: true));
        Navigator.of(event.context).pushNamedAndRemoveUntil('/login', (route)=> false);
      }
    );
  }

}