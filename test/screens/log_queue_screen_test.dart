import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart'; // ADDED
import 'package:free_cal_counter1/screens/log_queue_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'log_queue_screen_test.mocks.dart';

@GenerateMocks([
  LogProvider,
  NavigationProvider,
  FoodSearchProvider,
]) // ADDED FoodSearchProvider
void main() {
  late MockLogProvider mockLogProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockFoodSearchProvider mockFoodSearchProvider; // ADDED

  setUp(() {
    mockLogProvider = MockLogProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockFoodSearchProvider = MockFoodSearchProvider(); // ADDED

    // Stub necessary getters for FoodSearchProvider
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
        ), // ADDED
      ],
      child: const MaterialApp(home: LogQueueScreen()),
    );
  }

  testWidgets('tapping close button pops screen when queue is empty', (
    tester,
  ) async {
    when(mockLogProvider.logQueue).thenReturn([]);
    when(mockLogProvider.totalCalories).thenReturn(0.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // How to verify pop? We can check if the screen is gone.
    // For now, let's just ensure no dialog is shown.
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('shows discard dialog when queue is not empty', (tester) async {
    final food = Food(
      id: 1,
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      emoji: '🍎',
      source: 'test',
    );
    when(mockLogProvider.logQueue).thenReturn([food]);
    when(mockLogProvider.totalCalories).thenReturn(52.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Discard changes?'), findsOneWidget);
  });

  testWidgets('tapping cancel on dialog does nothing', (tester) async {
    final food = Food(
      id: 1,
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      emoji: '🍎',
      source: 'test',
    );
    when(mockLogProvider.logQueue).thenReturn([food]);
    when(mockLogProvider.totalCalories).thenReturn(52.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    verifyNever(mockLogProvider.clearQueue());
    verifyNever(mockNavigationProvider.changeTab(any));
  });

  testWidgets('tapping discard on dialog clears queue and navigates', (
    tester,
  ) async {
    final food = Food(
      id: 1,
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      emoji: '🍎',
      source: 'test',
    );
    when(mockLogProvider.logQueue).thenReturn([food]);
    when(mockLogProvider.totalCalories).thenReturn(52.0);
    when(mockLogProvider.dailyTargetCalories).thenReturn(2000.0);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    verify(mockLogProvider.clearQueue()).called(1);
    verify(mockNavigationProvider.changeTab(0)).called(1);
    // We can't easily test popUntil here, but we verified the provider calls.
  });
}
