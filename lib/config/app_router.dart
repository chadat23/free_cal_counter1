import 'package:flutter/material.dart';
import 'package:free_cal_counter1/screens/qr_sharing_screen.dart';
import 'package:free_cal_counter1/screens/data_management_screen.dart';
import 'package:free_cal_counter1/screens/search_screen.dart';
import 'package:free_cal_counter1/models/recipe.dart';
import 'package:free_cal_counter1/screens/home_screen.dart';
import 'package:free_cal_counter1/screens/log_queue_screen.dart';
import 'package:free_cal_counter1/screens/recipe_edit_screen.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/services/search_service.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/search_provider.dart';
import 'package:free_cal_counter1/models/search_config.dart';
import 'package:free_cal_counter1/models/quantity_edit_config.dart';

class AppRouter {
  static const String homeRoute = '/';
  static const String searchRoute = '/food_search';
  static const String logQueueRoute = '/log_queue';
  static const String recipeEditRoute = '/recipe_edit';
  static const String dataManagementRoute = '/data_management';
  static const String qrSharingRoute = '/qr_sharing';

  final DatabaseService databaseService;
  final OffApiService offApiService;
  final SearchService searchService;

  AppRouter({
    required this.databaseService,
    required this.offApiService,
    required this.searchService,
  });

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case searchRoute:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => SearchProvider(
              databaseService: databaseService,
              offApiService: offApiService,
              searchService: searchService,
            ),
            child: const SearchScreen(
              config: SearchConfig(
                context: QuantityEditContext.day,
                title: 'Food Search',
                showQueueStats: true,
              ),
            ),
          ),
        );
      case logQueueRoute:
        return MaterialPageRoute(builder: (_) => const LogQueueScreen());
      case recipeEditRoute:
        return MaterialPageRoute(builder: (_) => const RecipeEditScreen());
      case dataManagementRoute:
        return MaterialPageRoute(builder: (_) => const DataManagementScreen());
      case qrSharingRoute:
        final recipe = settings.arguments as Recipe?;
        return MaterialPageRoute(
          builder: (_) => QrSharingScreen(recipeToShare: recipe),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name ?? ''}',
              ), // Handle null settings.name
            ),
          ),
        );
    }
  }
}
