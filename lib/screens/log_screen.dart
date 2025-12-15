import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/log_header.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/logged_food.dart';
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
      await logProvider.loadLoggedFoodsForDate(_selectedDate);
    }
  }

  void _handleDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    logProvider.loadLoggedFoodsForDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final List<NutritionTarget> nutritionTargets = [
      NutritionTarget(
        color: Colors.blue,
        thisAmount: 2500,
        targetAmount: 2000,
        macroLabel: '🔥',
        unitLabel: '',
        dailyAmounts: [],
      ),
      NutritionTarget(
        color: Colors.red,
        thisAmount: 100,
        targetAmount: 150,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyAmounts: [],
      ),
      NutritionTarget(
        color: Colors.orange,
        thisAmount: 50,
        targetAmount: 70,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyAmounts: [],
      ),
      NutritionTarget(
        color: Colors.green,
        thisAmount: 200,
        targetAmount: 250,
        macroLabel: 'C',
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
                final meals = _groupLogsIntoMeals(logProvider.loggedFoods);

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

  List<Meal> _groupLogsIntoMeals(List<LoggedFood> loggedFoods) {
    if (loggedFoods.isEmpty) return [];

    // Sort by timestamp
    loggedFoods.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final meals = <Meal>[];

    if (loggedFoods.isEmpty) return [];

    var currentMealLogs = <LoggedFood>[loggedFoods.first];

    for (var i = 1; i < loggedFoods.length; i++) {
      final current = loggedFoods[i];
      final previous = loggedFoods[i - 1];

      final difference = current.timestamp
          .difference(previous.timestamp)
          .inMinutes
          .abs();

      if (difference > 60) {
        // Start new meal
        meals.add(
          Meal(
            timestamp: currentMealLogs.first.timestamp,
            loggedFoods: List.from(currentMealLogs),
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
        loggedFoods: List.from(currentMealLogs),
      ),
    );

    return meals;
  }

  void _updateLoggedFood(LoggedFood oldFood, FoodPortion newPortion) {
    // TODO: Implement update logic in LogProvider/DatabaseService
    print('Update logged food not implemented yet');
  }

  void _deleteLoggedFood(LoggedFood food) {
    Provider.of<LogProvider>(context, listen: false).deleteLoggedFood(food);
  }
}
