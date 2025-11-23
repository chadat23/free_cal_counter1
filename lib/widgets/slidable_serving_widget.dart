```dart
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/widgets/serving_widget.dart';

class SlidableServingWidget extends StatelessWidget {
  final FoodPortion serving;
  final VoidCallback onDelete;

  const SlidableServingWidget({
    super.key,
    required this.serving,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ServingWidget(serving: serving);
  }
}
```
