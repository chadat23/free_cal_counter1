import 'package:free_cal_counter1/models/food_portion.dart';

class LoggedFood {
  final int? id;
  final FoodPortion portion;
  final DateTime timestamp;

  LoggedFood({this.id, required this.portion, required this.timestamp});
}
