import 'package:flutter/material.dart';
import 'package:yatra_app/themes/dashboard_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: DashboardTheme.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Welcome to Yatra', style: DashboardTheme.greetingStyle),
              const SizedBox(height: 10),
              Text('Your travel guide across the city', style: DashboardTheme.subGreetingStyle),

              const SizedBox(height: 30),

              // Large Transit Illustration or Logo
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DashboardTheme.accentColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/yatra(logo).png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Navigation Buttons
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      dashboardButton(context, 'View Routes', Icons.map,),
                      const SizedBox(height: 16),
                      dashboardButton(context, 'Nearby Stops', Icons.location_on),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardButton(BuildContext context, String label, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate if needed
        },
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: DashboardTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
