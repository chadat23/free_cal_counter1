import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/screens/food_search_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_search_ribbon_test.mocks.dart';

@GenerateMocks([LogProvider, NavigationProvider, FoodSearchProvider])
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider;

  setUp(() {
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider(); // Use the mock
    when(mockNavigationProvider.shouldFocusSearch).thenReturn(false);
    when(mockNavigationProvider.resetSearchFocus()).thenReturn(null);
    when(mockFoodSearchProvider.selectedFood).thenReturn(null);
    when(mockFoodSearchProvider.searchResults).thenReturn([]);
    when(mockFoodSearchProvider.isOffSearchActive).thenReturn(false); // Default to inactive
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
    when(mockLogProvider.logQueue).thenReturn([]);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogProvider>.value(value: mockLogProvider),
        ChangeNotifierProvider<NavigationProvider>.value(value: mockNavigationProvider),
        ChangeNotifierProvider<FoodSearchProvider>.value(value: mockFoodSearchProvider), // Use the mock
      ],
      child: MaterialApp(
        navigatorKey: GlobalKey<NavigatorState>(),
        home: const Scaffold(
          body: FoodSearchRibbon(),
        ),
        onGenerateRoute: (settings) {
          if (settings.name == AppRouter.foodSearchRoute) {
            return MaterialPageRoute(
              builder: (_) => const FoodSearchScreen(),
            );
          }
          return null;
        },
      ),
    );
  }

  testWidgets('tapping search bar navigates to food search screen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byKey(const Key('food_search_text_field')));
    await tester.pumpAndSettle();

    expect(find.byType(FoodSearchScreen), findsOneWidget);
  });

  group('OFF Button', () {
    testWidgets('toggles OFF search and changes button color', (WidgetTester tester) async {
      // Arrange
      when(mockFoodSearchProvider.isOffSearchActive).thenReturn(false); // Initially inactive
      await tester.pumpWidget(createTestWidget());

      final offButtonFinder = find.widgetWithIcon(ElevatedButton, Icons.language);
      expect(offButtonFinder, findsOneWidget);

      // Act - Tap to activate OFF search
      await tester.tap(offButtonFinder);
      await tester.pump(); // Rebuild the widget after state change

      // Assert - Verify toggleOffSearch was called
      verify(mockFoodSearchProvider.toggleOffSearch(true)).called(1);
      when(mockFoodSearchProvider.isOffSearchActive).thenReturn(true); // Simulate state change

      // Act - Tap again to deactivate OFF search
      await tester.tap(offButtonFinder);
      await tester.pump(); // Rebuild the widget after state change

      // Assert - Verify toggleOffSearch was called
      verify(mockFoodSearchProvider.toggleOffSearch(false)).called(1);
    });
  });
}