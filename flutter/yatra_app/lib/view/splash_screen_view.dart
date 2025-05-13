import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:yatra_app/model/splash_model.dart';
import 'package:yatra_app/view/signin_view.dart';

class SplashScreenView extends StatelessWidget {
  final SplashModel _viewmodel = SplashModel();

  SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _viewmodel.initApp(), 
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          return AnimatedSplashScreen(
            splash: Image.asset('assets/icons/yatra(logo).png'), 
            splashIconSize: 200,
            backgroundColor: Colors.white,
            splashTransition: SplashTransition.fadeTransition,
            duration: 2500,
            nextScreen: SigninView()
          );
        }else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }

      );
  }
}