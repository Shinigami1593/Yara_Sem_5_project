import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
// import 'package:yatra_app/app/themes/dashboard_theme.dart';
import 'package:yatra_app/feature/splash/presentation/view/splash_screen_view.dart';
import 'package:yatra_app/feature/splash/presentation/view_model/splash_screen_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatra',
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashScreenView(),
      ),
    );
  }
}