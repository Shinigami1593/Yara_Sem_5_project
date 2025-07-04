import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/feature/auth/presentation/view/signin_view.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String? error;

  void _signup(BuildContext innerContext) {
  if (password != confirmPassword) {
    setState(() {
      error = 'Passwords do not match';
    });
    return;
  }
  if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
    setState(() {
      error = 'Please fill all fields';
    });
    return;
  }

  innerContext.read<RegisterViewModel>().add(
    RegisterUserEvent(
      context: innerContext,
      fullName: fullName,
      email: email,
      password: password,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<RegisterViewModel>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A3C34),
        body: Builder(
          builder: (innerContext) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          Icon(Icons.directions_bus, size: 50, color: Colors.white),
                          Text('YATRA',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(height: 8),
                          Text('Create Your Account',
                              style: TextStyle(fontSize: 20, color: Colors.white70)),
                        ],
                      ),
                    ),
                    TextField(
                      onChanged: (value) => fullName = value,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => email = value,
                      decoration: InputDecoration(
                        hintText: 'Gmail',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => confirmPassword = value,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
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
                      onPressed: () => _signup(innerContext), // Pass innerContext
                      child: const Text("SIGN UP", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.push(
                        innerContext,
                        MaterialPageRoute(builder: (_) => const SignInView()),
                      ),
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
