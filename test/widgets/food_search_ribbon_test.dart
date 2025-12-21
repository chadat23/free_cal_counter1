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

import 'package:free_cal_counter1/models/search_mode.dart';
import 'food_search_ribbon_test.mocks.dart';

@GenerateMocks([LogProvider, NavigationProvider, FoodSearchProvider])
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider;

  setUp(() {
    provideDummy<Future<void>>(Future.value());
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider(); // Use the mock
    when(mockNavigationProvider.shouldFocusSearch).thenReturn(false);
    when(mockNavigationProvider.resetSearchFocus()).thenReturn(null);
    when(mockNavigationProvider.showConsumed).thenReturn(true);
    when(mockFoodSearchProvider.searchResults).thenReturn([]);
    when(mockFoodSearchProvider.errorMessage).thenReturn(null); // ADDED
    when(mockFoodSearchProvider.isLoading).thenReturn(false); // ADDED
    when(mockFoodSearchProvider.searchMode).thenReturn(SearchMode.text);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.totalProtein).thenReturn(0.0);
    when(mockLogProvider.totalFat).thenReturn(0.0);
    when(mockLogProvider.totalCarbs).thenReturn(0.0);
    when(mockLogProvider.totalFiber).thenReturn(0.0);
    when(mockLogProvider.queuedCalories).thenReturn(0.0);
    when(mockLogProvider.queuedProtein).thenReturn(0.0);
    when(mockLogProvider.queuedFat).thenReturn(0.0);
    when(mockLogProvider.queuedCarbs).thenReturn(0.0);
    when(mockLogProvider.queuedFiber).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
    when(mockLogProvider.dailyTargetProtein).thenReturn(150.0);
    when(mockLogProvider.dailyTargetFat).thenReturn(70.0);
    when(mockLogProvider.dailyTargetCarbs).thenReturn(250.0);
    when(mockLogProvider.dailyTargetFiber).thenReturn(30.0);
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
    testWidgets('tapping OFF button calls onOffSearch callback', (
      WidgetTester tester,
    ) async {
      // Arrange
      var offSearchCalled = false;
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NavigationProvider>.value(
              value: mockNavigationProvider,
            ),
            ChangeNotifierProvider<LogProvider>.value(
              // Added because LogProvider is now required
              value: mockLogProvider,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FoodSearchRibbon(
                onOffSearch: () {
                  offSearchCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      final offButtonFinder = find.widgetWithIcon(
        ElevatedButton,
        Icons.language,
      );
      expect(offButtonFinder, findsOneWidget);

      // Act
      await tester.tap(offButtonFinder);
      await tester.pump(); // Rebuild the widget after state change

      // Assert
      expect(offSearchCalled, isTrue);
    });
  });

  testWidgets('tapping Log button saves queue and navigates home', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockLogProvider.logQueueToDatabase()).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget());

    final logButtonFinder = find.widgetWithText(ElevatedButton, 'Log');
    expect(logButtonFinder, findsOneWidget);

    // Act
    await tester.tap(logButtonFinder);
    await tester.pumpAndSettle();

    // Assert
    verify(mockLogProvider.logQueueToDatabase()).called(1);
    verify(mockNavigationProvider.changeTab(0)).called(1);
  });
}
