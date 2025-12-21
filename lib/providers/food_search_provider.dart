import 'package:flutter/foundation.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/services/food_search_service.dart';
import 'package:free_cal_counter1/models/search_mode.dart';

class FoodSearchProvider extends ChangeNotifier {
  final DatabaseService databaseService;
  final OffApiService offApiService;
  final FoodSearchService foodSearchService;

  FoodSearchProvider({
    required this.databaseService,
    required this.offApiService,
    required this.foodSearchService,
  });

  List<model.Food> _searchResults = [];
  List<model.Food> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _currentQuery = '';

  SearchMode _searchMode = SearchMode.text;
  SearchMode get searchMode => _searchMode;

  void setSearchMode(SearchMode mode) {
    _searchMode = mode;
    notifyListeners();
  }

  void _clearErrorMessage() {
    _errorMessage = null;
  }

  // Always performs a local search
  Future<void> textSearch(String query) async {
    _currentQuery = query;
    _isLoading = true;
    _clearErrorMessage();
    notifyListeners();

    try {
      _searchResults = await foodSearchService.searchLocal(query);
    } catch (e) {
      _errorMessage = 'Failed to search for food: ${e.toString()}';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Performs a one-time external search for the current query
  Future<void> performOffSearch() async {
    if (_currentQuery.isEmpty) return;

    _isLoading = true;
    _clearErrorMessage();
    notifyListeners();

    try {
      _searchResults = await foodSearchService.searchOff(_currentQuery);
    } catch (e) {
      _errorMessage = 'Failed to search for food: ${e.toString()}';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> barcodeSearch(String barcode) async {
    _isLoading = true;
    _clearErrorMessage();
    notifyListeners();

    try {
      model.Food? food = await databaseService.getFoodByBarcode(barcode);
      food ??= await offApiService.fetchFoodByBarcode(barcode);

      _searchResults = food == null ? [] : [food];
    } catch (e) {
      _errorMessage = 'Failed to search by barcode: ${e.toString()}';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
