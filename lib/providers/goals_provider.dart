import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/macro_goals.dart';

class GoalsProvider extends ChangeNotifier {
  // Currently hardcoded as per Phase 2 simplified plan
  final MacroGoals _currentGoals = MacroGoals.hardcoded();

  MacroGoals get currentGoals => _currentGoals;

  // Future methods for updating goals can be added here
}
