// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/app/shared_pref/auth_shared_preferences.dart';
import 'package:yatra_app/core/common/snackbar/snackbar.dart';
import 'package:yatra_app/core/network/biometric_service.dart';
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
      // Check biometric availability first
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

      // Check if biometrics enabled in storage
      final bool isBiometricEnabled = await SimpleStorageService.isBiometricEnabled();
      
      if (!isBiometricEnabled) {
        // Show dialog asking user if they want to set up biometric login
        final bool? shouldSetup = await showDialog<bool>(
          context: innerContext,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.fingerprint, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Setup Biometric Login'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fingerprint, size: 48, color: Colors.orange),
                  SizedBox(height: 16),
                  Text(
                    'Biometric login is not set up yet. Would you like to enable it? You\'ll need to login with your credentials first.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Setup'),
                ),
              ],
            );
          },
        );

        if (shouldSetup != true) return;

        // Redirect to manual login
        showMySnackBar(
          context: innerContext,
          message: 'Please login with your credentials to enable biometric login.',
          color: Colors.orange,
        );
        return;
      }

      // Authenticate biometrically
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login to YATRA',
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

      // Retrieve stored email for auto-login
      final storedEmail = await SimpleStorageService.getStoredEmail();

      if (storedEmail == null) {
        showMySnackBar(
          context: innerContext,
          message: 'No stored credentials found. Please login manually first.',
          color: Colors.red,
        );
        return;
      }

      // Trigger login event with stored email
      innerContext.read<LoginViewModel>().add(
            LoginWithEmailAndPasswordEvent(
              context: innerContext,
              username: storedEmail,
              password: '', // Handle this appropriately in your login logic
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

  Future<void> _promptBiometricSetup(BuildContext context) async {
    // Check if biometric is available
    final bool isAvailable = await BiometricService.isAvailable();
    if (!isAvailable) return;

    // Check if already enabled
    final bool isEnabled = await SimpleStorageService.isBiometricEnabled();
    if (isEnabled) return;

    // Show dialog to enable biometric
    final bool? shouldEnable = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.fingerprint, color: const Color(0xFF00C853)),
              SizedBox(width: 8),
              Text('Enable Quick Login'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fingerprint, size: 48, color: const Color(0xFF00C853)),
              SizedBox(height: 16),
              Text(
                'Would you like to enable biometric login for faster and more secure access to YATRA?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Not Now'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Enable'),
            ),
          ],
        );
      },
    );

    if (shouldEnable == true) {
      try {
        final bool authenticated = await BiometricService.authenticate(
          reason: 'Authenticate to enable biometric login for YATRA',
        );
        
        if (authenticated) {
          await SimpleStorageService.setBiometricEnabled(true);
          showMySnackBar(
            context: context,
            message: 'Biometric login enabled! You can now use it to sign in quickly.',
            color: Colors.green,
          );
        }
      } catch (e) {
        showMySnackBar(
          context: context,
          message: 'Failed to enable biometric login: $e',
          color: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<LoginViewModel>(),
      child: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            // Save credentials for future biometric login
            await SimpleStorageService.saveCredentials(email.trim(), ''); // Save email, token can be empty or actual token
            
            // Check if biometric is available and not yet enabled
            final bool isAvailable = await BiometricService.isAvailable();
            final bool isEnabled = await SimpleStorageService.isBiometricEnabled();
            
            if (isAvailable && !isEnabled) {
              // Prompt biometric setup after successful login
              await _promptBiometricSetup(context);
            }
            
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
                        // Optional: Lottie animation for fingerprint
                        // You can uncomment this if you have the animation file
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 40),
                        //   child: Lottie.asset(
                        //     'assets/animation/biometrics.json',
                        //     height: 150,
                        //     repeat: true,
                        //   ),
                        // ),

                        // Logo and welcome texts
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

                        const SizedBox(height: 32),

                        // Email field
                        TextField(
                          onChanged: (value) => email = value,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.email, color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextField(
                          onChanged: (value) => password = value,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),

                        // Forgot password
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

                        // Error message
                        if (error != null) ...[
                          const SizedBox(height: 12),
                          Text(error!, style: const TextStyle(color: Colors.white)),
                        ],

                        const SizedBox(height: 24),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C853),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: state.isLoading ? null : () => _login(innerContext),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white38)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white38)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Biometric login section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _loginWithBiometrics(innerContext),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white38),
                                  ),
                                  child: const Icon(
                                    Icons.fingerprint,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Login with Biometrics',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Quick and secure access',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Sign up link
                        TextButton(
                          onPressed: () => Navigator.push(
                            innerContext,
                            MaterialPageRoute(builder: (_) => const SignUpView()),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.white70),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                    color: Color(0xFF00C853),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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