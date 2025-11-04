import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
        ChangeNotifierProvider(
          create: (_) => FoodSearchProvider(
            databaseService: DatabaseService.instance,
            offApiService: OffApiService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'FreeCal Counter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[850],
          brightness: Brightness.dark,
        ),
        initialRoute: AppRouter.homeRoute,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
