import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/screens/overview_screen.dart';
import 'package:free_cal_counter1/models/daily_macro_stats.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'overview_screen_test.mocks.dart';

@GenerateMocks([LogProvider, NavigationProvider, FoodSearchProvider])
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider;

  setUp(() {
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider();

    // Stub LogProvider
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);
    when(mockLogProvider.getDailyMacroStats(any, any)).thenAnswer(
      (_) async => List.generate(
        7,
        (index) => DailyMacroStats(
          date: DateTime.now().subtract(Duration(days: 6 - index)),
        ),
      ),
    );
    when(mockLogProvider.getTodayStats()).thenAnswer(
      (_) async => DailyMacroStats(
        date: DateTime.now(),
        calories: 0,
        protein: 0,
        fat: 0,
        carbs: 0,
        fiber: 0,
      ),
    );

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
      child: const MaterialApp(home: OverviewScreen()),
    );
  }

  group('OverviewScreen', () {
    testWidgets('renders NutritionTargetsOverviewChart and FoodActionButtons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(NutritionTargetsOverviewChart), findsOneWidget);
      expect(find.byType(FoodSearchRibbon), findsOneWidget);
    });
  });
}
