
import 'package:flutter/foundation.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';

class FoodSearchProvider extends ChangeNotifier {
  final DatabaseService databaseService;
  final OffApiService offApiService;

  FoodSearchProvider({
    required this.databaseService,
    required this.offApiService,
  });

  List<model.Food> _searchResults = [];
  List<model.Food> get searchResults => _searchResults;

  Future<void> textSearch(String query) async {
    _searchResults = await databaseService.searchFoodsByName(query);
    notifyListeners();
  }

  Future<void> barcodeSearch(String barcode) async {
    model.Food? food = await databaseService.getFoodByBarcode(barcode);
    if (food == null) {
      food = await offApiService.fetchFoodByBarcode(barcode);
    }

    _searchResults = food == null ? [] : [food];
    notifyListeners();
  }

  Future<model.Food?> selectFood(model.Food food) async {
    if (food.id == 0) { // From OFF
      return await databaseService.saveFood(food);
    } else { // From reference DB
      final existing = await databaseService.getFoodBySourceFdcId(food.id);
      if (existing != null) {
        return existing;
      } else {
        final newFood = model.Food(
          id: 0, // Save as a new food
          name: food.name,
          emoji: food.emoji,
          calories: food.calories,
          protein: food.protein,
          fat: food.fat,
          carbs: food.carbs,
        );
        return await databaseService.saveFood(newFood);
      }
    }
  }
}
