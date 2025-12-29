import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/quantity_edit_config.dart';

typedef FoodSearchSaveCallback = void Function(FoodPortion portion);

class FoodSearchConfig {
  final QuantityEditContext context;
  final String title;
  final bool showQueueStats;
  final FoodSearchSaveCallback? onSaveOverride;

  const FoodSearchConfig({
    required this.context,
    required this.title,
    this.showQueueStats = true,
    this.onSaveOverride,
  });
}
