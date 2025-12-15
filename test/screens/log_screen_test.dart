import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/screens/log_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/widgets/log_header.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/services/reference_database.dart';
import 'package:drift/native.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/logged_food.dart' as model;
import 'package:free_cal_counter1/models/food_portion.dart' as model;
import 'package:free_cal_counter1/models/food_serving.dart' as model_serving;
import 'package:free_cal_counter1/widgets/meal_widget.dart';
import 'log_screen_test.mocks.dart';

@GenerateMocks([
  LogProvider,
  NavigationProvider,
  FoodSearchProvider,
  DatabaseService,
])
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider;

  setUp(() {
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider();

    // Initialize in-memory databases for testing
    final liveDb = LiveDatabase(connection: NativeDatabase.memory());
    final refDb = ReferenceDatabase(connection: NativeDatabase.memory());
    DatabaseService.initSingletonForTesting(liveDb, refDb);

    // Stub actual LogProvider getters
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
    // Stub loadLoggedFoodsForDate to avoid null errors if called
    when(mockLogProvider.loadLoggedFoodsForDate(any)).thenAnswer((_) async {});
    when(mockLogProvider.loggedFoods).thenReturn([]);

    // Stub NavigationProvider
    when(mockNavigationProvider.changeTab(any)).thenAnswer((_) {});

    // Stub FoodSearchProvider
    when(mockFoodSearchProvider.errorMessage).thenReturn(null);
    when(mockFoodSearchProvider.isLoading).thenReturn(false);
    when(mockFoodSearchProvider.searchResults).thenReturn([]);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogProvider>.value(value: mockLogProvider),
        ChangeNotifierProvider<NavigationProvider>.value(
          value: mockNavigationProvider,
        ),
        ChangeNotifierProvider<FoodSearchProvider>.value(
          value: mockFoodSearchProvider,
        ),
      ],
      child: const MaterialApp(home: LogScreen()),
    );
  }

  group('LogScreen', () {
    testWidgets('renders LogHeader and FoodSearchRibbon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(LogHeader), findsOneWidget);
      expect(find.byType(FoodSearchRibbon), findsOneWidget);
    });

    testWidgets('groups logs with identical timestamp into one meal', (
      tester,
    ) async {
      final time = DateTime(2023, 10, 20, 10, 20);

      final food = model.Food(
        id: 1,
        name: 'Apple',
        calories: 100,
        protein: 0,
        fat: 0,
        carbs: 20,
        fiber: 0,
        emoji: '🍎',
        source: 'test',
        servings: [
          model_serving.FoodServing(
            id: 1,
            foodId: 1,
            unit: 'g',
            grams: 1.0,
            quantity: 1.0,
          ),
        ],
      );

      final loggedFood1 = model.LoggedFood(
        id: 1,
        portion: model.FoodPortion(food: food, grams: 100, unit: 'g'),
        timestamp: time,
      );

      final loggedFood2 = model.LoggedFood(
        id: 2,
        portion: model.FoodPortion(food: food, grams: 100, unit: 'g'),
        timestamp: time,
      );

      when(mockLogProvider.loggedFoods).thenReturn([loggedFood1, loggedFood2]);

      await tester.pumpWidget(createTestWidget());

      // Should be 1 meal containing both
      expect(find.byType(MealWidget), findsOneWidget);
    });

    testWidgets(
      'separates logs with different timestamps into different meals',
      (tester) async {
        // 10:20
        final time1 = DateTime(2023, 10, 20, 10, 20);
        // 10:21 (Just 1 minute later)
        final time2 = DateTime(2023, 10, 20, 10, 21);

        final food = model.Food(
          id: 1,
          name: 'Apple',
          calories: 100,
          protein: 0,
          fat: 0,
          carbs: 20,
          fiber: 0,
          emoji: '🍎',
          source: 'test',
          servings: [
            model_serving.FoodServing(
              id: 1,
              foodId: 1,
              unit: 'g',
              grams: 1.0,
              quantity: 1.0,
            ),
          ],
        );

        final loggedFood1 = model.LoggedFood(
          id: 1,
          portion: model.FoodPortion(food: food, grams: 100, unit: 'g'),
          timestamp: time1,
        );

        final loggedFood2 = model.LoggedFood(
          id: 2,
          portion: model.FoodPortion(food: food, grams: 100, unit: 'g'),
          timestamp: time2,
        );

        when(
          mockLogProvider.loggedFoods,
        ).thenReturn([loggedFood1, loggedFood2]);

        await tester.pumpWidget(createTestWidget());

        // Should be 2 distinct meals
        expect(find.byType(MealWidget), findsNWidgets(2));
      },
    );
  });
}
