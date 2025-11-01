import 'package:flutter/material.dart';
import 'package:free_cal_counter1/screens/food_search_screen.dart';
import 'package:free_cal_counter1/screens/home_screen.dart';

class AppRouter {
  static const String homeRoute = '/';
  static const String foodSearchRoute = '/food_search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case foodSearchRoute:
        return MaterialPageRoute(builder: (_) => const FoodSearchScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name ?? ''}',
              ), // Handle null settings.name
            ),
          ),
        );
    }
  }
}
