import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/screens/food_search_screen.dart';
import 'package:free_cal_counter1/screens/serving_edit_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:drift/native.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/live_database.dart' as live_db;
import 'package:free_cal_counter1/services/reference_database.dart' as ref_db;

import 'food_search_screen_test.mocks.dart';

@GenerateMocks([LogProvider, NavigationProvider, FoodSearchProvider])
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider;

  setUpAll(() async {
    // Initialize DatabaseService with in-memory databases for testing
    final liveDb = live_db.LiveDatabase(connection: NativeDatabase.memory());
    final refDb = ref_db.ReferenceDatabase(connection: NativeDatabase.memory());
    DatabaseService.initSingletonForTesting(liveDb, refDb);
  });

  setUp(() {
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider();
    when(mockNavigationProvider.shouldFocusSearch).thenReturn(false);
    when(mockNavigationProvider.resetSearchFocus()).thenReturn(null);
    when(mockFoodSearchProvider.searchResults).thenReturn([]);
    when(mockFoodSearchProvider.isLoading).thenReturn(false);
    when(mockFoodSearchProvider.errorMessage).thenReturn(null);
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
      child: const MaterialApp(home: FoodSearchScreen()),
    );
  }

  testWidgets(
    'FoodSearchScreen displays error message when errorMessage is not null',
    (WidgetTester tester) async {
      when(mockLogProvider.logQueue).thenReturn([]);
      when(mockLogProvider.totalCalories).thenReturn(0.0);
      when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
      when(mockFoodSearchProvider.isLoading).thenReturn(false);
      when(
        mockFoodSearchProvider.errorMessage,
      ).thenReturn('Test Error Message');

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Test Error Message'), findsOneWidget);
    },
  );

  testWidgets(
    'FoodSearchScreen displays a CircularProgressIndicator when loading',
    (WidgetTester tester) async {
      when(mockLogProvider.logQueue).thenReturn([]);
      when(mockLogProvider.totalCalories).thenReturn(0.0);
      when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
      when(mockFoodSearchProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('FoodSearchScreen has a close button and calorie display', (
    WidgetTester tester,
  ) async {
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('0 / 2000'), findsOneWidget);
  });

  testWidgets('FoodSearchScreen has a FoodSearchRibbon', (
    WidgetTester tester,
  ) async {
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(FoodSearchRibbon), findsOneWidget);
  });

  testWidgets('tapping close button pops screen when queue is empty', (
    tester,
  ) async {
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
    when(mockNavigationProvider.changeTab(any)).thenReturn(null);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    verify(mockNavigationProvider.goBack()).called(1);
  });

  testWidgets('shows discard dialog when queue is not empty', (tester) async {
    final food = Food(
      id: 1,
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      fiber: 0.0,
      emoji: '🍎',
      source: 'test',
      servings: [],
    );
    final serving = FoodPortion(food: food, grams: 1, unit: 'g');
    when(mockLogProvider.logQueue).thenReturn([serving]);
    when(mockLogProvider.totalCalories).thenReturn(52.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Discard changes?'), findsOneWidget);
  });

  testWidgets('tapping on a search result navigates to ServingEditScreen', (
    tester,
  ) async {
    final food = Food(
      id: 1,
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      fiber: 0.0,
      emoji: '🍎',
      source: 'test',
      servings: [
        FoodServing(id: 1, foodId: 1, unit: 'g', grams: 1.0, quantity: 1.0),
      ],
    );
    when(mockFoodSearchProvider.searchResults).thenReturn([food]);
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('🍎 Apple'));
    await tester.pumpAndSettle();

    expect(find.byType(ServingEditScreen), findsOneWidget);
  });

  testWidgets(
    'should display food icons in the top ribbon when queue is not empty',
    (tester) async {
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 52,
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        fiber: 0.0,
        emoji: '🍎',
        source: 'test',
        servings: [
          FoodServing(id: 1, foodId: 1, unit: 'g', grams: 1.0, quantity: 1.0),
        ],
      );
      final serving = FoodPortion(food: food, grams: 1, unit: 'g');
      when(mockLogProvider.logQueue).thenReturn([serving]);
      when(mockLogProvider.totalCalories).thenReturn(52.0);
      when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('🍎'), findsOneWidget);
    },
  );
}
