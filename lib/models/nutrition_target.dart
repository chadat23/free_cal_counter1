import 'package:flutter/material.dart';

class NutritionTarget {
  final Color color;
  final double value;
  final double maxValue;
  final String macroLabel;
  final String unitLabel;
  final List<double> dailyValues;

  NutritionTarget({
    required this.color,
    required this.value,
    required this.maxValue,
    required this.macroLabel,
    required this.unitLabel,
    required this.dailyValues,
  });
}
