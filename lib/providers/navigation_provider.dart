import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  bool _shouldFocusSearch = false;

  int get selectedIndex => _selectedIndex;
  bool get shouldFocusSearch => _shouldFocusSearch;

  void changeTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void goToFoodSearch() {
    _previousIndex = _selectedIndex;
    _shouldFocusSearch = true;
    // A value that doesn't correspond to any tab
    _selectedIndex = -1;
    notifyListeners();
  }

  void resetSearchFocus() {
    _shouldFocusSearch = false;
    // No need to notify listeners for this change
  }

  void goBack() {
    _selectedIndex = _previousIndex;
    notifyListeners();
  }
}
