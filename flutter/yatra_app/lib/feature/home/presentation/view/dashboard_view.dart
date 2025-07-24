import 'package:flutter/material.dart';
import 'package:yatra_app/feature/home/presentation/view/bottom_navigation/home_view.dart';
import 'package:yatra_app/feature/auth/presentation/view/profile/profile.dart';
import 'package:yatra_app/feature/home/presentation/view/bottom_navigation/routes_view.dart';
import 'package:yatra_app/feature/home/presentation/view/bottom_navigation/stops_view.dart';
// import 'package:yatra_app/view/routes_view.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    RoutesView(),
    StopsView(),
    ProfileView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
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
