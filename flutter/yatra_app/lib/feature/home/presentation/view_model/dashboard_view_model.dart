import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/feature/auth/presentation/view/signin_view.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:yatra_app/feature/home/presentation/view_model/dashboard_state.dart';

class DashboardViewModel extends Cubit<DashboardState> {
  DashboardViewModel({required this.loginViewModel}) : super(DashboardState.initial());

  final LoginViewModel loginViewModel;

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    // Wait for 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BlocProvider.value(value: loginViewModel, child: SignInView()),
          ),
        );
      }
    });
  }
}
