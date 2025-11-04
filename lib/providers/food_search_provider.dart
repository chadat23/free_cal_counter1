
import 'package:flutter/foundation.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_unit.dart' as model_unit;
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

  model.Food? _selectedFood;
  model.Food? get selectedFood => _selectedFood;

  List<model_unit.FoodUnit> _units = [];
  List<model_unit.FoodUnit> get units => _units;

  Future<void> textSearch(String query) async {
    _searchResults = await databaseService.searchFoodsByName(query);
    notifyListeners();
  }

  Future<void> barcodeSearch(String barcode) async {
    model.Food? food = await databaseService.getFoodByBarcode(barcode);
    food ??= await offApiService.fetchFoodByBarcode(barcode);

    _searchResults = food == null ? [] : [food];
    notifyListeners();
  }

  void clearSelection() {
    _selectedFood = null;
    _units = [];
    notifyListeners();
  }

  Future<void> selectFood(model.Food food) async {
    _selectedFood = food;
    _units = await databaseService.getUnitsForFood(food);
    notifyListeners();
  }
}
