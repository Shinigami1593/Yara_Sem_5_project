import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 10,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.greenAccent,
                      )
                    ),
                    Positioned(
                      right: 10,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.teal,
                      )
                    ),
                    Positioned(
                      top: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green[700],
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              Text(
                'Yatra',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              
              SizedBox(height: 8),

              Text(
                'Embark on your journey with Yatra\ntoday!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
