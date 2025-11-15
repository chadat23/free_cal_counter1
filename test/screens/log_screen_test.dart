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

import 'log_screen_test.mocks.dart';

@GenerateMocks([LogProvider, NavigationProvider, FoodSearchProvider])
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider;

  setUp(() {
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider();

    // Stub actual LogProvider getters
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

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

    // These tests are commented out because the current LogProvider and models
    // do not support the functionality they are trying to test (meal lists, date navigation).
    // They would require significant changes to LogProvider and associated models
    // to be re-enabled.

    // testWidgets('renders a list of meals', (tester) async {
    //   final mockFood = Food(id: 1, name: 'Apple', calories: 52, protein: 0.3, fat: 0.2, carbs: 14, emoji: '🍎', source: 'test');
    //   final mockFoodServing = FoodServing(food: mockFood, servingSize: 100, servingUnit: 'g');
    //   final mockLoggedFood = LoggedFood(serving: mockFoodServing, timestamp: DateTime.now());
    //   final mockMeal = Meal(timestamp: DateTime.now(), loggedFoods: [mockLoggedFood]);

    //   when(mockLogProvider.mealsForDate).thenReturn([mockMeal, mockMeal]); // Stub with mock data
    //   await tester.pumpWidget(createTestWidget());

    //   expect(find.byType(MealWidget), findsNWidgets(2));
    // });

    // testWidgets('date navigation works correctly', (tester) async {
    //   when(mockLogProvider.currentDate).thenReturn(DateTime.now()); // Stub current date
    //   when(mockLogProvider.previousDay()).thenAnswer((_) async {});
    //   when(mockLogProvider.nextDay()).thenAnswer((_) async {});

    //   await tester.pumpWidget(createTestWidget());

    //   expect(find.text('Today'), findsOneWidget);

    //   await tester.tap(find.byIcon(Icons.chevron_left));
    //   await tester.pumpAndSettle();

    //   // This would require more complex stubbing of currentDate to show 'Yesterday'
    //   // For now, we just verify the method call.
    //   verify(mockLogProvider.previousDay()).called(1);

    //   await tester.tap(find.byIcon(Icons.chevron_right));
    //   await tester.pumpAndSettle();

    //   verify(mockLogProvider.nextDay()).called(1);

    //   await tester.tap(find.byIcon(Icons.chevron_right));
    //   await tester.pumpAndSettle();

    //   verify(mockLogProvider.nextDay()).called(2);
    // });
  });
}
