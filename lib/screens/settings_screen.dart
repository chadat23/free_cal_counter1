import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenBackground(
      child: Center(child: Text('Settings Screen')),
    );
  }
}
