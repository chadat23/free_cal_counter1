import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/recipe.dart';
import 'package:free_cal_counter1/models/recipe_item.dart';
import 'package:free_cal_counter1/models/category.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class RecipeProvider extends ChangeNotifier {
  String _name = '';
  double _servingsCreated = 1.0;
  double? _finalWeightGrams;
  String _portionName = 'portion';
  String _notes = '';
  bool _isTemplate = false;
  List<RecipeItem> _items = [];
  List<Category> _selectedCategories = [];

  bool _isLoading = false;

  // Getters
  String get name => _name;
  double get servingsCreated => _servingsCreated;
  double? get finalWeightGrams => _finalWeightGrams;
  String get portionName => _portionName;
  String get notes => _notes;
  bool get isTemplate => _isTemplate;
  List<RecipeItem> get items => List.unmodifiable(_items);
  List<Category> get selectedCategories =>
      List.unmodifiable(_selectedCategories);
  bool get isLoading => _isLoading;

  // Setters
  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setServingsCreated(double val) {
    _servingsCreated = val;
    notifyListeners();
  }

  void setFinalWeightGrams(double? val) {
    _finalWeightGrams = val;
    notifyListeners();
  }

  void setPortionName(String val) {
    _portionName = val;
    notifyListeners();
  }

  void setNotes(String val) {
    _notes = val;
    notifyListeners();
  }

  void setIsTemplate(bool val) {
    _isTemplate = val;
    notifyListeners();
  }

  // Item Operations
  void addItem(RecipeItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateItem(int index, RecipeItem newItem) {
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      notifyListeners();
    }
  }

  // Category Operations
  void toggleCategory(Category category) {
    if (_selectedCategories.any((c) => c.id == category.id)) {
      _selectedCategories.removeWhere((c) => c.id == category.id);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  // Macro Calculations (Computed)
  double get totalCalories =>
      _items.fold(0, (sum, item) => sum + (item.calories * item.grams));
  double get totalProtein =>
      _items.fold(0, (sum, item) => sum + (item.protein * item.grams));
  double get totalFat =>
      _items.fold(0, (sum, item) => sum + (item.fat * item.grams));
  double get totalCarbs =>
      _items.fold(0, (sum, item) => sum + (item.carbs * item.grams));
  double get totalFiber =>
      _items.fold(0, (sum, item) => sum + (item.fiber * item.grams));

  double get caloriesPerPortion =>
      servingsCreated > 0 ? totalCalories / servingsCreated : 0;
  // ... other macros per portion if needed

  // Persistence
  Future<void> saveRecipe() async {
    if (_name.isEmpty || _items.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final recipe = Recipe(
        id: 0, // Database will assign
        name: _name,
        servingsCreated: _servingsCreated,
        finalWeightGrams: _finalWeightGrams,
        portionName: _portionName,
        notes: _notes,
        isTemplate: _isTemplate,
        hidden: false,
        createdTimestamp: DateTime.now().millisecondsSinceEpoch,
        items: _items,
        categories: _selectedCategories,
      );

      await DatabaseService.instance.saveRecipe(recipe);
      reset();
    } catch (e) {
      // Handle error (maybe add an errorMessage state)
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _name = '';
    _servingsCreated = 1.0;
    _finalWeightGrams = null;
    _portionName = 'portion';
    _notes = '';
    _isTemplate = false;
    _items = [];
    _selectedCategories = [];
    notifyListeners();
  }

  void loadFromRecipe(Recipe recipe) {
    _name = recipe.name;
    _servingsCreated = recipe.servingsCreated;
    _finalWeightGrams = recipe.finalWeightGrams;
    _portionName = recipe.portionName;
    _notes = recipe.notes ?? '';
    _isTemplate = recipe.isTemplate;
    _items = List.from(recipe.items);
    _selectedCategories = List.from(recipe.categories);
    notifyListeners();
  }
}
