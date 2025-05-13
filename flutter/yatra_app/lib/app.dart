import 'package:flutter/material.dart';
import 'package:yatra_app/view/splash_screen_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatra',
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(),
    );
  }
}