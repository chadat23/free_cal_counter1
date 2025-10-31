import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/log_header.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/models/meal.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/logged_food.dart';
import 'package:free_cal_counter1/widgets/meal_widget.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  DateTime _selectedDate = DateTime.now();

  void _handleDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
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

    final meals = [
      Meal(
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        loggedFoods: [
          LoggedFood(
            portion: FoodPortion(
              food: Food(
                id: 1,
                name: 'Apple',
                emoji: '🍎',
                calories: 52,
                protein: 0.3,
                fat: 0.2,
                carbs: 14,
              ),
              servingSize: 100,
              servingUnit: 'g',
            ),
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          LoggedFood(
            portion: FoodPortion(
              food: Food(
                id: 2,
                name: 'Banana',
                emoji: '🍌',
                calories: 89,
                protein: 1.1,
                fat: 0.3,
                carbs: 23,
              ),
              servingSize: 150,
              servingUnit: 'g',
            ),
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      Meal(
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        loggedFoods: [
          LoggedFood(
            portion: FoodPortion(
              food: Food(
                id: 3,
                name: 'Chicken Breast',
                emoji: '🍗',
                calories: 165,
                protein: 31,
                fat: 3.6,
                carbs: 0,
              ),
              servingSize: 100,
              servingUnit: 'g',
            ),
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
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
            child: ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return MealWidget(meal: meals[index]);
              },
            ),
          ),
          const FoodSearchRibbon(),
        ],
      ),
    );
  }
}
