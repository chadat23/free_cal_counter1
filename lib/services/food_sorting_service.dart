import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_usage_stats.dart';
import 'package:free_cal_counter1/models/recipe.dart';

class FoodSortingService {
  /// Sort live foods by usage statistics (frequency-based for now)
  /// Foods with higher frequency appear first
  /// Alphabetical as tie-breaker for same frequency
  List<Food> sortLiveFoods(
    List<Food> foods,
    Map<int, FoodUsageStats>? usageStats,
  ) {
    if (usageStats == null || usageStats.isEmpty) {
      // Fallback to alphabetical if no usage stats
      return _sortAlphabetically(foods);
    }

    // Calculate scores based on frequency
    final scoredFoods = foods.map((food) {
      final stats = usageStats[food.id];
      if (stats == null) {
        return {'food': food, 'score': 0.0};
      }
      
      // Simple frequency-based scoring for now
      // Framework in place to add recency and time-of-day later
      final score = stats.logCount.toDouble();
      
      return {'food': food, 'score': score};
    }).toList();

    // Sort by score (higher is better), then alphabetically as tie-breaker
    scoredFoods.sort((a, b) {
      final scoreA = a['score'] as double;
      final scoreB = b['score'] as double;
      if (scoreA != scoreB) {
        return scoreB.compareTo(scoreA); // Descending
      }
      return (a['food'] as Food).name.toLowerCase().compareTo(
        (b['food'] as Food).name.toLowerCase(),
      );
    });

    return scoredFoods.map((e) => e['food'] as Food).toList();
  }

  /// Sort reference foods with fuzzy matching
  /// Uses same fuzzy matching algorithm as final search
  /// Alphabetical as tie-breaker for same scores
  List<Food> sortReferenceFoods(List<Food> foods, String query) {
    if (query.isEmpty) {
      return _sortAlphabetically(foods);
    }

    return _applyFuzzyMatching(query, foods);
  }

  /// Pre-filter recipes with fuzzy matching, then sort by usage statistics
  /// Alphabetical as tie-breaker for same frequency
  List<Recipe> sortRecipes(
    List<Recipe> recipes,
    Map<int, FoodUsageStats>? usageStats,
    String query,
  ) {
    // Pre-filter with fuzzy matching if query provided
    List<Recipe> filteredRecipes = recipes;
    if (query.isNotEmpty) {
      filteredRecipes = _applyFuzzyMatchingToRecipes(query, recipes);
    }

    // Sort by usage statistics
    if (usageStats == null || usageStats.isEmpty) {
      return _sortRecipesAlphabetically(filteredRecipes);
    }

    final scoredRecipes = filteredRecipes.map((recipe) {
      final stats = usageStats[recipe.id];
      if (stats == null) {
        return {'recipe': recipe, 'score': 0.0};
      }
      
      final score = stats.logCount.toDouble();
      
      return {'recipe': recipe, 'score': score};
    }).toList();

    scoredRecipes.sort((a, b) {
      final scoreA = a['score'] as double;
      final scoreB = b['score'] as double;
      if (scoreA != scoreB) {
        return scoreB.compareTo(scoreA); // Descending
      }
      return (a['recipe'] as Recipe).name.toLowerCase().compareTo(
        (b['recipe'] as Recipe).name.toLowerCase(),
      );
    });

    return scoredRecipes.map((e) => e['recipe'] as Recipe).toList();
  }

  /// Apply fuzzy matching to foods
  /// Same algorithm as SearchService._applyFuzzyMatching
  List<Food> _applyFuzzyMatching(String query, List<Food> foods) {
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
        // Use token set ratio for everything else
        score = 100 - fuzzy.tokenSetRatio(lowerCaseName, lowerCaseQuery);
      }
      return {'food': food, 'score': score};
    }).toList();

    // Sort by score (lower is better), then alphabetically as tie-breaker
    scoredFoods.sort((a, b) {
      final scoreA = a['score'] as int;
      final scoreB = b['score'] as int;
      if (scoreA != scoreB) {
        return scoreA.compareTo(scoreB);
      }
      return (a['food'] as Food).name.toLowerCase().compareTo(
        (b['food'] as Food).name.toLowerCase(),
      );
    });

    return scoredFoods.map((e) => e['food'] as Food).toList();
  }

  /// Apply fuzzy matching to recipes
  List<Recipe> _applyFuzzyMatchingToRecipes(String query, List<Recipe> recipes) {
    if (query.isEmpty || recipes.isEmpty) {
      return [];
    }
    final lowerCaseQuery = query.toLowerCase();

    final scoredRecipes = recipes.map((recipe) {
      final lowerCaseName = recipe.name.toLowerCase();
      int score;

      if (lowerCaseName == lowerCaseQuery) {
        score = 0;
      } else if (lowerCaseName.startsWith(lowerCaseQuery)) {
        score = 1;
      } else if (lowerCaseName.contains(' $lowerCaseQuery')) {
        score = 2;
      } else {
        score = 100 - fuzzy.tokenSetRatio(lowerCaseName, lowerCaseQuery);
      }
      return {'recipe': recipe, 'score': score};
    }).toList();

    scoredRecipes.sort((a, b) {
      final scoreA = a['score'] as int;
      final scoreB = b['score'] as int;
      if (scoreA != scoreB) {
        return scoreA.compareTo(scoreB);
      }
      return (a['recipe'] as Recipe).name.toLowerCase().compareTo(
        (b['recipe'] as Recipe).name.toLowerCase(),
      );
    });

    return scoredRecipes.map((e) => e['recipe'] as Recipe).toList();
  }

  /// Sort foods alphabetically (case-insensitive)
  List<Food> _sortAlphabetically(List<Food> foods) {
    final sorted = List<Food>.from(foods);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  /// Sort recipes alphabetically (case-insensitive)
  List<Recipe> _sortRecipesAlphabetically(List<Recipe> recipes) {
    final sorted = List<Recipe>.from(recipes);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }
}
