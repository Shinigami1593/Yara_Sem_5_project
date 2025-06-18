import 'package:flutter/material.dart';

class DashboardTheme {
  static const Color primaryColor = Color(0xFF00C853);
  static const Color accentColor = Color(0xFF66BB6A);
  static const Color backgroundColor = Color(0xFF1B1F1D);
  static const Color textColor = Colors.white;

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);

  static const String fontFamily = 'Urbanist';

  static const TextStyle greetingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subGreetingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle routeTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle routeSubtitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
}
