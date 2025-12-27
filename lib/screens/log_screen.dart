import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/log_header.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/logged_portion.dart';
import 'package:free_cal_counter1/models/meal.dart';
import 'package:free_cal_counter1/widgets/meal_widget.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/utils/debug_seeder.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // Seed data if needed (debug only)
    await DebugSeeder.seed();

    if (mounted) {
      // Load logs for the selected date
      final logProvider = Provider.of<LogProvider>(context, listen: false);
      await logProvider.loadLoggedPortionsForDate(_selectedDate);
    }
  }

  void _handleDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    logProvider.loadLoggedPortionsForDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate nutrition targets from logged foods
    final loggedFoods = Provider.of<LogProvider>(context).loggedPortion;

    // We can use the helper from DailyMacroStats, but we need to map LoggedFood to DTO first
    // OR just sum them up here since we have the full objects already.
    // However, to be DRY and consistent, let's use the same logic if possible.
    // Actually, LogProvider already computed _loggedFoods for us.
    // Calculating stats for detailed views from the list is trivial:

    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;
    double totalFiber = 0;

    for (var food in loggedFoods) {
      totalCalories += food.portion.food.calories * food.portion.grams;
      totalProtein += food.portion.food.protein * food.portion.grams;
      totalFat += food.portion.food.fat * food.portion.grams;
      totalCarbs += food.portion.food.carbs * food.portion.grams;
      totalFiber += food.portion.food.fiber * food.portion.grams;
    }

    final List<NutritionTarget> nutritionTargets = [
      NutritionTarget(
        color: Colors.blue,
        thisAmount: totalCalories,
        targetAmount: 2000, // TODO: settings
        macroLabel: '🔥',
        unitLabel: '',
        dailyAmounts: [], // Not used in LogHeader yet
      ),
      NutritionTarget(
        color: Colors.red,
        thisAmount: totalProtein,
        targetAmount: 150,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyAmounts: [],
      ),
      NutritionTarget(
        color: Colors.orange,
        thisAmount: totalFat,
        targetAmount: 70,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyAmounts: [],
      ),
      NutritionTarget(
        color: Colors.green,
        thisAmount: totalCarbs,
        targetAmount: 250,
        macroLabel: 'C',
        unitLabel: 'g',
        dailyAmounts: [],
      ),
      NutritionTarget(
        color: Colors.brown,
        thisAmount: totalFiber,
        targetAmount: 30,
        macroLabel: 'Fb',
        unitLabel: 'g',
        dailyAmounts: [],
      ),
    ];

    return ScreenBackground(
      child: Column(
        children: [
          LogHeader(
            date: _selectedDate,
            onDateChanged: _handleDateChanged,
            nutritionTargets: nutritionTargets,
          ),
          Expanded(
            child: Consumer<LogProvider>(
              builder: (context, logProvider, child) {
                final meals = _groupLogsIntoMeals(logProvider.loggedPortion);

                if (meals.isEmpty) {
                  return const Center(child: Text('No logs for this day'));
                }

                return ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return MealWidget(
                      meal: meals[index],
                      onFoodUpdated: _updateLoggedFood,
                      onFoodDeleted: _deleteLoggedFood,
                    );
                  },
                );
              },
            ),
          ),
          const FoodSearchRibbon(),
        ],
      ),
    );
  }

  List<Meal> _groupLogsIntoMeals(List<LoggedPortion> loggedPortions) {
    if (loggedPortions.isEmpty) return [];

    // Sort by timestamp
    loggedPortions.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final meals = <Meal>[];

    if (loggedPortions.isEmpty) return [];

    var currentMealLogs = <LoggedPortion>[loggedPortions.first];

    for (var i = 1; i < loggedPortions.length; i++) {
      final current = loggedPortions[i];
      final previous = loggedPortions[i - 1];

      // Group essentially by exact timestamp (strict grouping)
      // Since queue items are logged with the same timestamp, they will group.
      // Separate logs (even 1 minute apart) will split.
      if (!current.timestamp.isAtSameMomentAs(previous.timestamp)) {
        // Start new meal
        meals.add(
          Meal(
            timestamp: currentMealLogs.first.timestamp,
            loggedPortion: List.from(currentMealLogs),
          ),
        );
        currentMealLogs = [current];
      } else {
        currentMealLogs.add(current);
      }
    }

    // Add the last meal
    meals.add(
      Meal(
        timestamp: currentMealLogs.first.timestamp,
        loggedPortion: List.from(currentMealLogs),
      ),
    );

    return meals;
  }

  void _updateLoggedFood(LoggedPortion oldFood, FoodPortion newPortion) {
    // TODO: Implement update logic in LogProvider/DatabaseService
    print('Update logged food not implemented yet');
  }

  void _deleteLoggedFood(LoggedPortion food) {
    Provider.of<LogProvider>(context, listen: false).deleteLoggedPortion(food);
  }
}
