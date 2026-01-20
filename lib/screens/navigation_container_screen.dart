import 'package:flutter/material.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/screens/log_screen.dart';
import 'package:free_cal_counter1/screens/overview_screen.dart';
import 'package:free_cal_counter1/screens/settings_screen.dart';
import 'package:free_cal_counter1/screens/weight_screen.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:provider/provider.dart';

class NavigationContainerScreen extends StatelessWidget {
  const NavigationContainerScreen({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    OverviewScreen(),
    LogScreen(),
    WeightScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.selectedIndex;

    // Check for weekly target update notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
      if (goalsProvider.showUpdateNotification) {
        _showUpdateDialog(context, goalsProvider);
      }
    });

    return Scaffold(
      body: Center(
        child: (selectedIndex >= 0 && selectedIndex < _widgetOptions.length)
            ? _widgetOptions.elementAt(selectedIndex)
            : Container(),
      ),
      bottomNavigationBar: (selectedIndex != -1)
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Overview',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Log'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.monitor_weight),
                  label: 'Weight',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.grey,
              onTap: (index) => navigationProvider.changeTab(index),
            )
          : null,
    );
  }

  void _showUpdateDialog(BuildContext context, GoalsProvider goalsProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Weekly Goal Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your weight targets have been updated for the new week.',
            ),
            const SizedBox(height: 10),
            Text(
              'New Calorie Target: ${goalsProvider.currentGoals.calories.toInt()} kcal',
            ),
            Text('Protein: ${goalsProvider.currentGoals.protein.toInt()}g'),
            Text('Fat: ${goalsProvider.currentGoals.fat.toInt()}g'),
            Text('Carbs: ${goalsProvider.currentGoals.carbs.toInt()}g'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              goalsProvider.dismissNotification();
              Navigator.pop(context);
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
