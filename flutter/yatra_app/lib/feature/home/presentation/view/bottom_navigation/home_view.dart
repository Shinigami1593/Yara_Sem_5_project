import 'package:flutter/material.dart';
import 'package:yatra_app/app/themes/dashboard_theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showMoreTips = false;
  int _tipIndex = 0;
  final List<String> _tips = [
    'Plan ahead with Yatra’s route planner for a stress-free trip.',
    'Check live updates to avoid delays during peak hours.',
    'Carry a charged device for uninterrupted navigation.',
    'Use the app offline for basic route information.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 32, 18),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: DashboardTheme.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Welcome to Yatra',
                style: DashboardTheme.greetingStyle.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Ultimate Travel Companion',
                style: DashboardTheme.subGreetingStyle.copyWith(fontSize: 18),
              ),

              const SizedBox(height: 30),

              // Hero Section with Logo
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DashboardTheme.accentColor.withOpacity(0.7),
                        DashboardTheme.accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DashboardTheme.accentColor.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/yatra(logo).png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Horizontal Scrollable Featured Section
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildFeatureSlide(
                      title: 'City Highlights',
                      description: 'Explore top destinations in the city.',
                      icon: Icons.home_work,
                    ),
                    const SizedBox(width: 16),
                    _buildFeatureSlide(
                      title: 'Live Updates',
                      description: 'Get real-time transit info.',
                      icon: Icons.update,
                    ),
                    const SizedBox(width: 16),
                    _buildFeatureSlide(
                      title: 'Travel Deals',
                      description: 'Unlock exclusive travel offers.',
                      icon: Icons.local_offer,
                    ),
                    const SizedBox(width: 16),
                    _buildFeatureSlide(
                      title: 'Safety Tips',
                      description: 'Stay safe with expert advice.',
                      icon: Icons.security,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Introduction Section
              Text(
                'About Yatra',
                style: DashboardTheme.greetingStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                'Yatra is your future go-to app for seamless city travel in Kathmandu City. With planned real-time route updates, nearby stop information, and timely alerts, it promises to help you navigate with ease, making travel smarter and more accessible.',
                style: DashboardTheme.subGreetingStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 40),

              // Testimonials Section
              Text(
                'What Users Say',
                style: DashboardTheme.greetingStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                name: 'Priya Sharma',
                feedback: 'Yatra has transformed my daily commute. The live updates are a game-changer!',
              ),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                name: 'Ravi Kumar',
                feedback: 'Easy to use and the route suggestions are spot on. Highly recommend!',
              ),

              const SizedBox(height: 40),

              // Quick Tips Section
              Text(
                'Quick Travel Tips',
                style: DashboardTheme.greetingStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildTipCard(tip: _tips[_tipIndex]),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tipIndex = (_tipIndex + 1) % _tips.length;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DashboardTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Next Tip'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showMoreTips = !_showMoreTips;
                  });
                },
                child: Text(
                  _showMoreTips ? 'Show Less Tips' : 'Show All Tips',
                  style: TextStyle(color: DashboardTheme.accentColor),
                ),
              ),
              if (_showMoreTips)
                Column(
                  children: _tips
                      .map((tip) => Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _buildTipCard(tip: tip),
                          ))
                      .toList(),
                ),

              const SizedBox(height: 40),

              // Visual Divider
              Center(
                child: Container(
                  width: 100,
                  height: 2,
                  color: DashboardTheme.accentColor.withOpacity(0.5),
                ),
              ),

              const SizedBox(height: 40),

              // Call to Action
              Text(
                'Start Exploring Today!',
                style: DashboardTheme.greetingStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                'Download Yatra now and experience a smarter way to travel. Available on iOS and Android!',
                style: DashboardTheme.subGreetingStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSlide({required String title, required String description, required IconData icon}) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: DashboardTheme.accentColor.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: DashboardTheme.accentColor),
          const SizedBox(height: 12),
          Text(
            title,
            style: DashboardTheme.greetingStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: DashboardTheme.subGreetingStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({required String name, required String feedback}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DashboardTheme.accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feedback,
            style: DashboardTheme.subGreetingStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '- $name',
            style: DashboardTheme.greetingStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({required String tip}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DashboardTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 24, color: DashboardTheme.accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: DashboardTheme.subGreetingStyle.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}