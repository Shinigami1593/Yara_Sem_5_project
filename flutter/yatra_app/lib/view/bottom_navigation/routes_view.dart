import 'package:flutter/material.dart';
import 'package:yatra_app/themes/dashboard_theme.dart';

class RoutesView extends StatelessWidget {
  const RoutesView({super.key});

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
              // Title and Greeting
              Text('Hello, User', style: DashboardTheme.greetingStyle),
              SizedBox(height: 8),
              Text('Where do you want to go today?', style: DashboardTheme.subGreetingStyle),

              SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search routes...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),

              SizedBox(height: 20),

              // Popular Routes
              Text('Popular Routes', style: DashboardTheme.sectionTitleStyle),
              SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: [
                    routeCard('Kalanki → Ratnapark', '20 mins'),
                    routeCard('Koteshwor → New Road', '25 mins'),
                    routeCard('Gongabu → Pulchowk', '30 mins'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget routeCard(String route, String duration) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.directions_bus, color: DashboardTheme.primaryColor),
        title: Text(route, style: TextStyle(color: Color(0xFF1A3C34))),
        subtitle: Text('Est. travel time: $duration', style: TextStyle(color: Color(0xFF1A3C34))),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
