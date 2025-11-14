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
    when(mockFoodSearchProvider.searchResults).thenReturn([]);
    when(mockFoodSearchProvider.errorMessage).thenReturn(null); // ADDED
    when(mockFoodSearchProvider.isLoading).thenReturn(false); // ADDED
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
    when(mockLogProvider.logQueue).thenReturn([]);
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
        ), // Use the mock
      ],
      child: MaterialApp(
        navigatorKey: GlobalKey<NavigatorState>(),
        home: const Scaffold(body: FoodSearchRibbon()),
        onGenerateRoute: (settings) {
          if (settings.name == AppRouter.foodSearchRoute) {
            return MaterialPageRoute(
              builder: (_) => MultiProvider(
                // ADDED MultiProvider
                providers: [
                  ChangeNotifierProvider<LogProvider>.value(
                    value: mockLogProvider,
                  ),
                  ChangeNotifierProvider<NavigationProvider>.value(
                    value: mockNavigationProvider,
                  ),
                  ChangeNotifierProvider<FoodSearchProvider>.value(
                    value: mockFoodSearchProvider,
                  ),
                ],
                child: const FoodSearchScreen(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  testWidgets('tapping search bar navigates to food search screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byKey(const Key('food_search_text_field')));
    await tester.pumpAndSettle();

    expect(find.byType(FoodSearchScreen), findsOneWidget);
  });

  group('OFF Button', () {
    testWidgets('tapping OFF button calls performOffSearch', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      final offButtonFinder = find.widgetWithIcon(
        ElevatedButton,
        Icons.language,
      );
      expect(offButtonFinder, findsOneWidget);

      // Act
      await tester.tap(offButtonFinder);
      await tester.pump(); // Rebuild the widget after state change

      // Assert
      verify(mockFoodSearchProvider.performOffSearch()).called(1);
    });
  });
}
