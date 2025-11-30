import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/emoji_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/services/food_search_service.dart'; // ADDED
import 'package:provider/provider.dart';
import 'package:openfoodfacts/openfoodfacts.dart'; // Import openfoodfacts

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();

  // Set user agent for OpenFoodFacts API
  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'FreeCalCounter',
    version: '1.0',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate services that will be injected
    final databaseService = DatabaseService.instance;
    final offApiService = OffApiService();
    final foodSearchService = FoodSearchService(
      // NEW
      databaseService: databaseService,
      offApiService: offApiService,
      emojiForFoodName: emojiForFoodName,
    );

    final appRouter = AppRouter(
      databaseService: databaseService,
      offApiService: offApiService,
      foodSearchService: foodSearchService,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
      ],
      child: MaterialApp(
        title: 'FreeCal Counter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[850],
          brightness: Brightness.dark,
        ),
        initialRoute: AppRouter.homeRoute,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
