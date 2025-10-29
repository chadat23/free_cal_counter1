import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const ScreenBackground({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: child,
      ),
    );
  }
}
