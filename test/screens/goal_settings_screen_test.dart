import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/screens/goal_settings_screen.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:free_cal_counter1/models/goal_settings.dart';
import 'package:free_cal_counter1/providers/weight_provider.dart';
import 'package:free_cal_counter1/models/weight.dart';

import 'goal_settings_screen_test.mocks.dart';

@GenerateMocks([GoalsProvider, WeightProvider])
void main() {
  late MockGoalsProvider mockGoalsProvider;
  late MockWeightProvider mockWeightProvider;

  setUp(() {
    mockGoalsProvider = MockGoalsProvider();
    mockWeightProvider = MockWeightProvider();

    // Stub the settings getter
    when(mockGoalsProvider.settings).thenReturn(GoalSettings.defaultSettings());

    // Stub weight provider
    when(mockWeightProvider.getWeightForDate(any)).thenReturn(null);
    when(mockWeightProvider.saveWeight(any, any)).thenAnswer((_) async {});
  });

  testWidgets('GoalSettingsScreen renders all fields and toggles', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalsProvider>.value(value: mockGoalsProvider),
          ChangeNotifierProvider<WeightProvider>.value(
            value: mockWeightProvider,
          ),
        ],
        child: const MaterialApp(home: GoalSettingsScreen()),
      ),
    );

    expect(find.text('Goals & Targets'), findsOneWidget);
    expect(find.text('Goal Mode'), findsOneWidget);
    expect(find.text('Current Weight (lb)'), findsOneWidget);
    expect(
      find.text('Anchor Weight (lb)'),
      findsOneWidget,
    ); // Default is Imperial
    expect(find.text('Use Metric Units (kg)'), findsOneWidget);

    // Scroll to see the save button
    final saveButton = find.text('Save Settings');
    await tester.scrollUntilVisible(
      saveButton,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Check for save button
    expect(saveButton, findsOneWidget);
  });

  testWidgets('Toggling metric updates the anchor weight label', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalsProvider>.value(value: mockGoalsProvider),
          ChangeNotifierProvider<WeightProvider>.value(
            value: mockWeightProvider,
          ),
        ],
        child: const MaterialApp(home: GoalSettingsScreen()),
      ),
    );

    expect(find.text('Anchor Weight (lb)'), findsOneWidget);

    // Tap the metric switch
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(find.text('Anchor Weight (kg)'), findsOneWidget);
    expect(find.text('Current Weight (kg)'), findsOneWidget);
  });

  testWidgets('Saving settings saves current weight', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalsProvider>.value(value: mockGoalsProvider),
          ChangeNotifierProvider<WeightProvider>.value(
            value: mockWeightProvider,
          ),
        ],
        child: const MaterialApp(home: GoalSettingsScreen()),
      ),
    );

    // Enter current weight
    await tester.enterText(
      find.widgetWithText(TextField, 'Current Weight (lb)'),
      '155.5',
    );

    // Scroll to save
    final saveButton = find.text('Save Settings');
    await tester.scrollUntilVisible(
      saveButton,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    verify(mockWeightProvider.saveWeight(155.5, any)).called(1);
    verify(mockGoalsProvider.saveSettings(any)).called(1);
  });
}
