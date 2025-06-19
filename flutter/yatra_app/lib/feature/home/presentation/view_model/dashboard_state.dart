import 'package:flutter/material.dart';
import 'package:yatra_app/feature/home/presentation/view/dashboard_view.dart';

class DashboardState {
  final int selectedIndex;
  final List<Widget> views;

  const DashboardState({required this.selectedIndex, required this.views});

  // Initial state
  static DashboardState initial() {
    return DashboardState(
      selectedIndex: 0,
      views: [
        DashboardView(),
      ],
    );
  }

  DashboardState copyWith({int? selectedIndex, List<Widget>? views}) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}
