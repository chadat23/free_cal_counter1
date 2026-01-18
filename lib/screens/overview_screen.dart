import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/search_ribbon.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:free_cal_counter1/models/daily_macro_stats.dart';
import 'package:free_cal_counter1/models/macro_goals.dart';
import 'package:free_cal_counter1/providers/weight_provider.dart';
import 'package:free_cal_counter1/widgets/weight_trend_chart.dart';
import 'package:free_cal_counter1/models/weight.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<NutritionTarget> _nutritionData = [];
  List<Weight> _weightHistory = [];
  bool _isLoading = true;
  int _weightRangeDays = 30;
  String _weightRangeLabel = '1 mo';

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
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final weightProvider = Provider.of<WeightProvider>(context, listen: false);
    final stats = await logProvider.getDailyMacroStats(start, today);
    final goals = goalsProvider.currentGoals;

    final rangeStart = today.subtract(Duration(days: _weightRangeDays));
    await weightProvider.loadWeights(rangeStart, today);
    final weightHistory = weightProvider.weights;

    // Process stats into NutritionTargets
    if (mounted) {
      setState(() {
        _nutritionData = _buildTargets(stats, goals);
        _weightHistory = weightHistory;
        _isLoading = false;
      });
    }
  }

  List<NutritionTarget> _buildTargets(
    List<DailyMacroStats> stats,
    MacroGoals goals,
  ) {
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
        targetAmount: goals.calories,
        macroLabel: '🔥',
        unitLabel: '',
        dailyAmounts: calories,
      ),
      NutritionTarget(
        color: Colors.red,
        thisAmount: todayStats.protein,
        targetAmount: goals.protein,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyAmounts: protein,
      ),
      NutritionTarget(
        color: Colors.yellow,
        thisAmount: todayStats.fat,
        targetAmount: goals.fat,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyAmounts: fat,
      ),
      NutritionTarget(
        color: Colors.green,
        thisAmount: todayStats.carbs,
        targetAmount: goals.carbs,
        macroLabel: 'C',
        unitLabel: 'g',
        dailyAmounts: carbs,
      ),
      NutritionTarget(
        color: Colors.brown,
        thisAmount: todayStats.fiber,
        targetAmount: goals.fiber,
        macroLabel: 'Fb',
        unitLabel: 'g',
        dailyAmounts: fiber,
      ),
    ];
  }

  Widget _buildRangeSelector() {
    final ranges = {
      '1 wk': 7,
      '1 mo': 30,
      '3 mo': 90,
      '6 mo': 180,
      '1 yr': 365,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ranges.entries.map((entry) {
        final isSelected = _weightRangeLabel == entry.key;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                _weightRangeLabel = entry.key;
                _weightRangeDays = entry.value;
                _isLoading = true;
              });
              _loadData();
            },
            style: TextButton.styleFrom(
              backgroundColor: isSelected ? Colors.white : Colors.transparent,
              foregroundColor: isSelected ? Colors.black : Colors.white,
              minimumSize: const Size(40, 32),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(entry.key, style: const TextStyle(fontSize: 12)),
          ),
        );
      }).toList(),
    );
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            WeightTrendChart(
                              weightHistory: _weightHistory,
                              timeframeLabel: _weightRangeLabel,
                            ),
                            const SizedBox(height: 8),
                            _buildRangeSelector(),
                          ],
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
