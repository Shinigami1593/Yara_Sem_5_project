import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yatra_app/model/splash_model.dart';
import 'package:yatra_app/view/signin_view.dart';

class SplashScreenView extends StatelessWidget {
  final SplashModel _viewmodel = SplashModel();

  SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _viewmodel.initApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSplashScreen(
            splash: Lottie.asset('assets/animation/bus_animation.json', height: 200),
            splashIconSize: 200,
            backgroundColor: Colors.white,
            splashTransition: SplashTransition.fadeTransition,
            duration: 2500,
            nextScreen: const SigninView(),
          );
        } else {
          return Scaffold(
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
