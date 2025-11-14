import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_unit.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/screens/portion_edit_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'portion_edit_screen_test.mocks.dart';

@GenerateMocks([LogProvider])
void main() {
  late MockLogProvider mockLogProvider;

  setUp(() {
    mockLogProvider = MockLogProvider();
  });

  final food = Food(
    id: 1,
    name: 'Apple',
    calories: 52,
    protein: 0.3,
    fat: 0.2,
    carbs: 14,
    source: 'test',
    units: [
      FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0),
      FoodUnit(id: 2, foodId: 1, name: 'slice', grams: 10.0),
    ],
  );

  testWidgets('should display food name, amount, and unit', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<LogProvider>.value(
        value: mockLogProvider,
        child: MaterialApp(
          home: PortionEditScreen(food: food),
        ),
      ),
    );

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('g'), findsOneWidget);
  });

  testWidgets('should call addFoodToQueue when Add button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<LogProvider>.value(
        value: mockLogProvider,
        child: MaterialApp(
          home: PortionEditScreen(food: food),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '2');
    await tester.tap(find.text('Add'));
    await tester.pump();

    verify(mockLogProvider.addFoodToQueue(any)).called(1);
  });

  testWidgets('should not call addFoodToQueue when Cancel button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<LogProvider>.value(
        value: mockLogProvider,
        child: MaterialApp(
          home: PortionEditScreen(food: food),
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    verifyNever(mockLogProvider.addFoodToQueue(any));
  });
}
