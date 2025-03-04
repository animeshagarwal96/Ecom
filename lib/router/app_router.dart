import 'package:ecom/features/dashboard/presentation/screens/dashboard.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );
    }
  }
}
