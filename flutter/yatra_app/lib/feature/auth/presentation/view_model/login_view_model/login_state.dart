import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? authToken;
  final String? userEmail;
  final Map<String, dynamic>? userData; // Optional: if you need to store additional user data

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.authToken,
    this.userEmail,
    this.userData,
  });

  const LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        errorMessage = '',
        authToken = null,
        userEmail = null,
        userData = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? authToken,
    String? userEmail,
    Map<String, dynamic>? userData,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      authToken: authToken ?? this.authToken,
      userEmail: userEmail ?? this.userEmail,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        errorMessage,
        authToken,
        userEmail,
        userData,
      ];
}