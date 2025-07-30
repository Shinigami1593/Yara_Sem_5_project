// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:local_auth/local_auth.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/app/shared_pref/auth_shared_preferences.dart';
import 'package:yatra_app/core/common/snackbar/snackbar.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:yatra_app/feature/home/presentation/view/dashboard_view.dart';
import 'package:yatra_app/feature/auth/presentation/view/signup_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  String email = '';
  String password = '';
  String? error;

  void _login(BuildContext innerContext) {
    if (email.isEmpty || password.isEmpty) {
      showMySnackBar(
        context: innerContext,
        message: 'Please enter both email and password.',
        color: Colors.red,
      );
      return;
    }

    innerContext.read<LoginViewModel>().add(
          LoginWithEmailAndPasswordEvent(
            context: innerContext,
            username: email.trim(),
            password: password.trim(),
          ),
        );
  }

  Future<void> _loginWithBiometrics(BuildContext innerContext) async {
    try {
      // Check if biometrics enabled in storage
      final bool isBiometricEnabled = await SimpleStorageService.isBiometricEnabled();
      if (!isBiometricEnabled) {
        showMySnackBar(
          context: innerContext,
          message: 'Biometric login is not enabled.',
          color: Colors.red,
        );
        return;
      }

      // Check biometric availability
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        showMySnackBar(
          context: innerContext,
          message: 'Biometric authentication not available on this device.',
          color: Colors.red,
        );
        return;
      }

      // Authenticate biometrically
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );

      if (!didAuthenticate) {
        showMySnackBar(
          context: innerContext,
          message: 'Biometric authentication failed.',
          color: Colors.red,
        );
        return;
      }

      // Retrieve stored email and token for auto-login
      final storedEmail = await SimpleStorageService.getStoredEmail();
      final storedToken = await SimpleStorageService.getStoredToken();

      if (storedEmail == null || storedToken == null) {
        showMySnackBar(
          context: innerContext,
          message: 'No stored credentials found. Please login manually.',
          color: Colors.red,
        );
        return;
      }

      // Trigger login event with stored email and token
      innerContext.read<LoginViewModel>().add(
            LoginWithEmailAndPasswordEvent(
              context: innerContext,
              username: storedEmail,
              password: '', // Password is not needed here; handle accordingly in your login logic if needed
            ),
          );
    } catch (e) {
      showMySnackBar(
        context: innerContext,
        message: 'Error during biometric login: $e',
        color: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<LoginViewModel>(),
      child: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardView()),
            );
          } else if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            showMySnackBar(
              context: context,
              message: state.errorMessage!,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A3C34),
            body: Builder(
              builder: (innerContext) => Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie animation for fingerprint
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Lottie.asset(
                            'assets/animation/biometrics.json',
                            height: 150,
                            repeat: true,
                          ),
                        ),

                        // Existing logo and welcome texts
                        const Column(
                          children: [
                            Icon(Icons.directions_bus, size: 50, color: Colors.white),
                            Text(
                              'YATRA',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          onChanged: (value) => email = value,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.email, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) => password = value,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 12),
                          Text(error!, style: const TextStyle(color: Colors.white)),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: state.isLoading ? null : () => _login(innerContext),
                          child: state.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("SIGN IN", style: TextStyle(fontSize: 16)),
                        ),

                        const SizedBox(height: 16),

                        // Fingerprint Icon Button for biometric login
                        GestureDetector(
                          onTap: () => _loginWithBiometrics(innerContext),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 48,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          'Login with Biometrics',
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.push(
                            innerContext,
                            MaterialPageRoute(builder: (_) => const SignUpView()),
                          ),
                          child: const Text(
                            "Don't have an account? Sign up",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
