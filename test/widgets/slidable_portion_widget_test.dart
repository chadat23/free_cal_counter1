import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/widgets/portion_widget.dart';
import 'package:free_cal_counter1/widgets/slidable_portion_widget.dart';

void main() {
  testWidgets('SlidablePortionWidget slides to reveal delete button and deletes on tap', (WidgetTester tester) async {
    // Given
    bool onDeleteCalled = false;
    final food = Food(id: 1, name: 'Apple', emoji: '🍎', calories: 52, protein: 0.3, fat: 0.2, carbs: 14);
    final portion = FoodPortion(food: food, servingSize: 100, servingUnit: 'g');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SlidablePortionWidget(
            portion: portion,
            onDelete: () {
              onDeleteCalled = true;
            },
          ),
        ),
      ),
    );

    // When
    await tester.drag(find.byType(SlidablePortionWidget), const Offset(-100, 0));
    await tester.pumpAndSettle();

    // Then
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // When
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Then
    expect(onDeleteCalled, isTrue);
  });


}