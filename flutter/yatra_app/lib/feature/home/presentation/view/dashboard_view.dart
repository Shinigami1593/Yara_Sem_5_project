import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:yatra_app/feature/home/presentation/view/bottom_navigation/home_view.dart';
import 'package:yatra_app/feature/auth/presentation/view/profile/profile.dart';
import 'package:yatra_app/feature/trips/presentation/view/routes_view.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_viewmodel.dart';
import 'package:yatra_app/feature/trips/presentation/view_model/trip_view_model.dart';
// import 'package:yatra_app/view/routes_view.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  // Remove 'const' and use function to inject BLoC
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return BlocProvider(
          create: (_) => serviceLocator<RouteViewModel>() ,
          child: const RoutesView(),
        );
      case 1:
        return BlocProvider(
          create: (_) => serviceLocator<TripViewModel>() ,
          child: const TripsView(),
        );
      case 2:
        return BlocProvider(
          create: (_) => serviceLocator<ProfileViewModel>(),
          child: const ProfileView(),
        );
      default:
        return const SizedBox();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF1A3C34),
        selectedItemColor: const Color(0xFF00C853),
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
