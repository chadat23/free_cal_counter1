import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/recipe.dart';
import 'package:free_cal_counter1/models/recipe_item.dart';
import 'package:free_cal_counter1/models/category.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class RecipeProvider extends ChangeNotifier {
  int _id = 0;
  int? _parentId;
  bool _isLogged = false;

  String _name = '';
  double _servingsCreated = 1.0;
  double? _finalWeightGrams;
  String _portionName = 'portion';
  String _notes = '';
  bool _isTemplate = false;
  List<RecipeItem> _items = [];
  List<Category> _selectedCategories = [];
  bool _ingredientsChanged = false;

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get id => _id;
  int? get parentId => _parentId;
  bool get isLogged => _isLogged;

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
  String? get errorMessage => _errorMessage;
  bool get ingredientsChanged => _ingredientsChanged;

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
    _ingredientsChanged = true;
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _ingredientsChanged = true;
      notifyListeners();
    }
  }

  void updateItem(int index, RecipeItem newItem) {
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      _ingredientsChanged = true;
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

  void loadFromRecipe(Recipe recipe, {bool isLogged = false}) {
    _id = recipe.id;
    _parentId = recipe.parentId;
    _name = recipe.name;
    _servingsCreated = recipe.servingsCreated;
    _finalWeightGrams = recipe.finalWeightGrams;
    _portionName = recipe.portionName;
    _notes = recipe.notes ?? '';
    _isTemplate = recipe.isTemplate;
    _items = List.from(recipe.items);
    _selectedCategories = List.from(recipe.categories);
    _isLogged = isLogged;
    _ingredientsChanged = false;
    notifyListeners();
  }

  void prepareCopy(Recipe recipe) {
    loadFromRecipe(recipe, isLogged: false);
    _id = 0;
    _parentId = null;
    _name = '${recipe.name} - Copy';
    notifyListeners();
  }

  void prepareVersion(Recipe recipe) {
    loadFromRecipe(recipe, isLogged: true);
    notifyListeners();
  }

  // Persistence
  Future<bool> saveRecipe() async {
    _errorMessage = null;
    if (_name.isEmpty) {
      _errorMessage = 'Please provide a name for the recipe.';
      notifyListeners();
      return false;
    }
    if (_items.isEmpty) {
      _errorMessage = 'Please add at least one ingredient.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final db = DatabaseService.instance;

      int? targetParentId = _parentId;
      int? originalToHide;

      if (_id > 0 && _isLogged && _ingredientsChanged) {
        targetParentId = _id;
        originalToHide = _id;
        _id = 0;
      }

      final recipe = Recipe(
        id: _id,
        name: _name,
        servingsCreated: _servingsCreated,
        finalWeightGrams: _finalWeightGrams,
        portionName: _portionName,
        notes: _notes,
        isTemplate: _isTemplate,
        hidden: false,
        parentId: targetParentId,
        createdTimestamp: DateTime.now().millisecondsSinceEpoch,
        items: _items,
        categories: _selectedCategories,
      );

      await db.saveRecipe(recipe);

      if (originalToHide != null) {
        await db.hideRecipe(originalToHide);
      }

      reset();
      return true;
    } catch (e) {
      debugPrint('Error saving recipe: $e');
      _errorMessage = 'Technical error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _id = 0;
    _parentId = null;
    _isLogged = false;
    _name = '';
    _servingsCreated = 1.0;
    _finalWeightGrams = null;
    _portionName = 'portion';
    _notes = '';
    _isTemplate = false;
    _items = [];
    _selectedCategories = [];
    _errorMessage = null;
    _ingredientsChanged = false;
    notifyListeners();
  }
}
