import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:yatra_app/feature/auth/presentation/view/signin_view.dart';
import 'package:yatra_app/feature/splash/presentation/view_model/splash_screen_view_model.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final splashViewModel = context.read<SplashViewModel>();

    return FutureBuilder(
      future: splashViewModel.init(context), // <- move logic into here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSplashScreen(
            splash: Lottie.asset('assets/animation/bus_animation.json', height: 200),
            splashIconSize: 200,
            backgroundColor: Colors.white,
            splashTransition: SplashTransition.fadeTransition,
            duration: 5000,
            nextScreen: const SignInView(),
            pageTransitionType: PageTransitionType.bottomToTop,
          );
        } else {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF07609b)),
            ),
          );
        }
      },
    );
  }
}