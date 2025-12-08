import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class DebugSeeder {
  static Future<void> seed() async {
    final now = DateTime.now();
    final todayLogs = await DatabaseService.instance.getLoggedPortionsForDate(
      now,
    );

    if (todayLogs.isNotEmpty) {
      print('DebugSeeder: Logs already exist for today. Skipping seed.');
      return;
    }

    print('DebugSeeder: Seeding database with test data...');

    // Fetch some foods from the database to log
    // We'll search for common items
    final foods = await DatabaseService.instance.searchFoodsByName('apple');
    if (foods.isEmpty) {
      print(
        'DebugSeeder: No foods found to seed. Make sure the DB is initialized.',
      );
      return;
    }

    final apple = foods.first;

    // Create portions for Today
    final todayPortions = [FoodPortion(food: apple, grams: 150, unit: 'g')];

    // Create portions for Yesterday
    final yesterdayPortions = [FoodPortion(food: apple, grams: 100, unit: 'g')];

    // Log them
    // Note: logFoods uses DateTime.now(), so we can't easily backdate with it directly
    // without modifying it or manually inserting.
    // For simplicity, we'll just log "today" stuff using the service.
    // For "yesterday", we might need a hack or just accept that we only seed today for now
    // unless we want to expose a date param in logFoods (which might be good anyway).

    // Actually, the user asked for yesterday too.
    // Let's modify logFoods to accept a date, or manually insert here.
    // Since logFoods is the "public" API, let's stick to using it for today.

    await DatabaseService.instance.logPortions(todayPortions, now);

    // For yesterday, we'll manually insert to avoid changing the public API just for seeding
    // OR we can make logFoods accept an optional date.
    // Let's check DatabaseService again. It uses DateTime.now().
    // I'll stick to seeding today for now to avoid overcomplicating,
    // but the user DID ask for yesterday.
    // "I want it to populate it for today and yesterday"

    // Okay, I will add an optional date parameter to logFoods in the next step.
    // For now, I'll write this seeder assuming logFoods takes a date,
    // and then I'll go update DatabaseService.

    await DatabaseService.instance.logPortions(todayPortions, now);
    await DatabaseService.instance.logPortions(
      yesterdayPortions,
      now.subtract(const Duration(days: 1)),
    );

    print('DebugSeeder: Seeding complete.');
  }
}
