import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3C34),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Image.asset("assets/icons/yatra(logo).png")
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    //NAvigation handle:
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00C853),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)
                    )
                  ),
                  child: Text(
                    'Start Your Journey',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white
                    ),
                  )
                  ),
                ), 
            ],
          ),
        ),
      ),
    );
  }
}
