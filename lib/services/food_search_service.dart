import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';

class FoodSearchService {
  final DatabaseService databaseService;
  final OffApiService offApiService;

  FoodSearchService({
    required this.databaseService,
    required this.offApiService,
  });

  // Helper function to apply fuzzy matching and sorting
  List<model.Food> _applyFuzzyMatching(String query, List<model.Food> foods) {
    if (query.isEmpty || foods.isEmpty) {
      return [];
    }
    final lowerCaseQuery = query.toLowerCase();

    // Score each food based on match quality
    final scoredFoods = foods.map((food) {
      final lowerCaseName = food.name.toLowerCase();
      int score;

      if (lowerCaseName == lowerCaseQuery) {
        score = 0; // Exact match = perfect score
      } else if (lowerCaseName.startsWith(lowerCaseQuery)) {
        score = 1; // Starts with = very high score
      } else if (lowerCaseName.contains(' $lowerCaseQuery')) {
        score = 2; // Contains as whole word = high score
      } else {
        // Use token set ratio for everything else.
        // We subtract from 100 because a higher ratio is better, but a lower sort score is better.
        score = 100 - fuzzy.tokenSetRatio(lowerCaseName, lowerCaseQuery);
      }
      return {'food': food, 'score': score};
    }).toList();

    // Sort by score (lower is better), then alphabetically as a tie-breaker
    scoredFoods.sort((a, b) {
      final scoreA = a['score'] as int;
      final scoreB = b['score'] as int;
      if (scoreA != scoreB) {
        return scoreA.compareTo(scoreB);
      }
      return (a['food'] as model.Food).name.toLowerCase().compareTo(
        (b['food'] as model.Food).name.toLowerCase(),
      );
    });

    final sortedFoods = scoredFoods
        .map((e) => e['food'] as model.Food)
        .toList();

    print('Tiered Search Query: "$query"');
    print('Tiered Search Candidates: ${foods.length}');
    print(
      'Tiered Search Top 5 Results: ${sortedFoods.take(5).map((f) => f.name).toList()}',
    );

    // Map back to list of foods and limit to a reasonable number
    return sortedFoods.take(50).toList();
  }

  Future<List<model.Food>> searchLocal(String query) async {
    print('--- EXECUTING LOCAL SEARCH ---');
    if (query.isEmpty) {
      return [];
    }
    final localResults = await databaseService.searchFoodsByName(query);
    return _applyFuzzyMatching(query, localResults);
  }

  Future<List<model.Food>> searchOff(String query) async {
    print('--- EXECUTING OFF SEARCH ---');
    if (query.isEmpty) {
      return [];
    }
    final offResults = await offApiService.searchFoodsByName(query);
    return _applyFuzzyMatching(query, offResults);
  }
}
