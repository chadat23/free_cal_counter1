import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void goToFoodSearch() {
    _previousIndex = _selectedIndex;
    // A value that doesn't correspond to any tab
    _selectedIndex = -1; 
    notifyListeners();
  }

  void goBack() {
    _selectedIndex = _previousIndex;
    notifyListeners();
  }
}
