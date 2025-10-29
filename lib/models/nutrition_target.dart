import 'package:flutter/material.dart';

class NutritionTarget {
  final Color color;
  final double value;
  final double maxValue;
  final String label;
  final String subLabel;
  final List<double> dailyValues;

  NutritionTarget({
    required this.color,
    required this.value,
    required this.maxValue,
    required this.label,
    required this.subLabel,
    required this.dailyValues,
  });
}
