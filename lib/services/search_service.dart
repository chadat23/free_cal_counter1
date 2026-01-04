import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';

class SearchService {
  final DatabaseService databaseService;
  final OffApiService offApiService;
  final String Function(String) emojiForFoodName;

  SearchService({
    required this.databaseService,
    required this.offApiService,
    required this.emojiForFoodName,
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

    // Map back to list of foods and limit to a reasonable number
    return sortedFoods.take(50).toList();
  }

  Future<List<model.Food>> searchLocal(String query, {int? categoryId}) async {
    if (query.isEmpty) {
      if (categoryId != null) {
        return searchRecipesOnly(query, categoryId: categoryId);
      }
      return [];
    }

    // Search both foods and recipes
    final localResults = await databaseService.searchFoodsByName(query);
    final recipeResults = await databaseService.getRecipesBySearch(
      query,
      categoryId: categoryId,
    );

    // Filter out foods that have a parent (older versions)
    // Note: DatabaseService.searchFoodsByName now handles this internally,
    // but we can leave this as a secondary safety check if we want,
    // though it's better to rely on DB for efficiency.
    final filteredResults = localResults;

    final combinedResults = [
      ...filteredResults,
      ...recipeResults.map((r) => r.toFood()),
    ];

    final usageNotes = await databaseService.getFoodsUsageNotes(
      combinedResults,
    );

    final resultsWithEmoji = combinedResults
        .map(
          (food) => food.copyWith(
            emoji: emojiForFoodName(food.name),
            usageNote: usageNotes[food.id],
          ),
        )
        .toList();
    return _applyFuzzyMatching(query, resultsWithEmoji);
  }

  Future<List<model.Food>> searchOff(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final offResults = await offApiService.searchFoodsByName(query);
    final usageNotes = await databaseService.getFoodsUsageNotes(offResults);

    final resultsWithEmoji = offResults
        .map(
          (food) => food.copyWith(
            emoji: emojiForFoodName(food.name),
            usageNote: usageNotes[food.id],
          ),
        )
        .toList();
    return _applyFuzzyMatching(query, resultsWithEmoji);
  }

  Future<List<model.Food>> getAllRecipesAsFoods({int? categoryId}) async {
    final recipes = await databaseService.getRecipesBySearch(
      '',
      categoryId: categoryId,
    );
    final foods = recipes.map((r) => r.toFood()).toList();
    final usageNotes = await databaseService.getFoodsUsageNotes(foods);

    // Map recipes to foods
    final resultsWithEmoji = foods.map((food) {
      return food.copyWith(
        emoji: emojiForFoodName(food.name),
        usageNote: usageNotes[food.id],
      );
    }).toList();

    return resultsWithEmoji;
  }

  Future<List<model.Food>> searchRecipesOnly(
    String query, {
    int? categoryId,
  }) async {
    final recipeResults = await databaseService.getRecipesBySearch(
      query,
      categoryId: categoryId,
    );
    final foods = recipeResults.map((r) => r.toFood()).toList();
    final usageNotes = await databaseService.getFoodsUsageNotes(foods);

    final resultsWithEmoji = foods.map((food) {
      return food.copyWith(
        emoji: emojiForFoodName(food.name),
        usageNote: usageNotes[food.id],
      );
    }).toList();

    return _applyFuzzyMatching(query, resultsWithEmoji);
  }
}
