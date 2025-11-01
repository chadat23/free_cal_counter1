
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Food Search'),
      ),
      body: const Center(
        child: Text('Food Search Screen'),
      ),
      bottomNavigationBar: const FoodSearchRibbon(),
    );
  }
}
