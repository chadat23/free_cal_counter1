import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/screens/weight_screen.dart';

void main() {
  testWidgets('WeightScreen UI and interaction test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: WeightScreen()));

    // Verify that the WeightScreen is rendered.
    expect(find.byType(WeightScreen), findsOneWidget);

    // Verify that the TextField and ElevatedButton are present.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Enter text into the TextField.
    await tester.enterText(find.byType(TextField), '75.5');

    // Tap the ElevatedButton.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the SnackBar is shown.
    expect(find.text('Weight saved: 75.5'), findsOneWidget);
  });
}
