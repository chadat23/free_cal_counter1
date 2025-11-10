import 'package:flutter/material.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/screens/log_screen.dart';
import 'package:free_cal_counter1/screens/overview_screen.dart';
import 'package:free_cal_counter1/screens/settings_screen.dart';
import 'package:free_cal_counter1/screens/weight_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
}
