import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/search_ribbon.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/models/daily_macro_stats.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<NutritionTarget> _nutritionData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: 6)); // Last 7 days

    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final stats = await logProvider.getDailyMacroStats(start, today);

    // Process stats into NutritionTargets
    if (mounted) {
      setState(() {
        _nutritionData = _buildTargets(stats);
        _isLoading = false;
      });
    }
  }

  List<NutritionTarget> _buildTargets(List<DailyMacroStats> stats) {
    // Extract daily lists (ensure 7 days, index 0 is oldest, index 6 is today)
    // DailyMacroStats.fromDTOS usually returns sorted by date
    // We already requested 7 days, so we should map them directly mostly.

    // Helper to map a field across the stats list
    List<double> mapField(double Function(DailyMacroStats) selector) {
      return stats.map(selector).toList();
    }

    final calories = mapField((s) => s.calories);
    final protein = mapField((s) => s.protein);
    final fat = mapField((s) => s.fat);
    final carbs = mapField((s) => s.carbs);
    final fiber = mapField((s) => s.fiber);

    // Get Today's values (last in the list)
    final todayStats = stats.last;

    return [
      NutritionTarget(
        color: Colors.blue,
        thisAmount: todayStats.calories,
        targetAmount: 2000.0, // TODO: Get from settings
        macroLabel: '🔥',
        unitLabel: '',
        dailyAmounts: calories,
      ),
      NutritionTarget(
        color: Colors.red,
        thisAmount: todayStats.protein,
        targetAmount: 150.0,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyAmounts: protein,
      ),
      NutritionTarget(
        color: Colors.yellow,
        thisAmount: todayStats.fat,
        targetAmount: 70.0,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyAmounts: fat,
      ),
      NutritionTarget(
        color: Colors.green,
        thisAmount: todayStats.carbs,
        targetAmount: 250.0,
        macroLabel: 'C',
        unitLabel: 'g',
        dailyAmounts: carbs,
      ),
      NutritionTarget(
        color: Colors.brown,
        thisAmount: todayStats.fiber,
        targetAmount: 30.0,
        macroLabel: 'Fb',
        unitLabel: 'g',
        dailyAmounts: fiber,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NutritionTargetsOverviewChart(
                          nutritionData: _nutritionData,
                        ),
                      ),
                    ],
                  ),
          ),
          const SearchRibbon(),
        ],
      ),
    );
  }
}
