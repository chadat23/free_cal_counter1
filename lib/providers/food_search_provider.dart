
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

  bool _isOffSearchActive = false;
  bool get isOffSearchActive => _isOffSearchActive;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _clearErrorMessage() {
    _errorMessage = null;
  }

  void toggleOffSearch(bool isActive) {
    _isOffSearchActive = isActive;
    notifyListeners();
  }

  Future<void> textSearch(String query) async {
    _isLoading = true;
    _clearErrorMessage(); // Clear any previous error
    notifyListeners(); // Notify listeners about loading state change

    try {
      if (_isOffSearchActive) {
        _searchResults = await offApiService.searchFoodsByName(query);
      } else {
        _searchResults = await databaseService.searchFoodsByName(query);
      }
    } catch (e) {
      _errorMessage = 'Failed to search for food: ${e.toString()}';
      _searchResults = []; // Clear results on error
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners about search results and loading state change
    }
  }

  Future<void> barcodeSearch(String barcode) async {
    _isLoading = true;
    _clearErrorMessage(); // Clear any previous error
    notifyListeners(); // Notify listeners about loading state change

    try {
      model.Food? food = await databaseService.getFoodByBarcode(barcode);
      food ??= await offApiService.fetchFoodByBarcode(barcode);

      _searchResults = food == null ? [] : [food];
    } catch (e) {
      _errorMessage = 'Failed to search by barcode: ${e.toString()}';
      _searchResults = []; // Clear results on error
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners about search results and loading state change
    }
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
