import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenBackground(
      child: Center(child: Text('Log Screen')),
    );
  }
}
