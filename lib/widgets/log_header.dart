import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/config/app_colors.dart';

class LogHeader extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final List<NutritionTarget> nutritionTargets;

  const LogHeader({
    super.key,
    required this.date,
    required this.onDateChanged,
    required this.nutritionTargets,
  });

  @override
  State<LogHeader> createState() => _LogHeaderState();
}

class _LogHeaderState extends State<LogHeader> {
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) {
      return 'Today';
    } else if (checkDate == yesterday) {
      return 'Yesterday';
    } else if (checkDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.largeWidgetBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  widget.onDateChanged(widget.date.subtract(const Duration(days: 1)));
                },
              ),
              const SizedBox(width: 8.0),
              Text(
                _formatDate(widget.date),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  widget.onDateChanged(widget.date.add(const Duration(days: 1)));
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: HorizontalMiniBarChart(
                  nutritionTarget: widget.nutritionTargets[0],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: HorizontalMiniBarChart(
                  nutritionTarget: widget.nutritionTargets[1],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: HorizontalMiniBarChart(
                  nutritionTarget: widget.nutritionTargets[2],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: HorizontalMiniBarChart(
                  nutritionTarget: widget.nutritionTargets[3],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}