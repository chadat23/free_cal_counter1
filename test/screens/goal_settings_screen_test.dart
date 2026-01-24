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

import 'package:free_cal_counter1/providers/navigation_provider.dart';

import 'goal_settings_screen_test.mocks.dart';

@GenerateMocks([GoalsProvider, WeightProvider, NavigationProvider])
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
    expect(
      find.text('Target Weight (lb)'),
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

  testWidgets('Toggling metric updates the target weight label', (
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

    expect(find.text('Target Weight (lb)'), findsOneWidget);

    // Tap the metric switch
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(find.text('Target Weight (kg)'), findsOneWidget);
  });

  testWidgets('Saving settings saves settings', (tester) async {
    when(
      mockGoalsProvider.saveSettings(
        any,
        isInitialSetup: anyNamed('isInitialSetup'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalsProvider>.value(value: mockGoalsProvider),
          ChangeNotifierProvider<NavigationProvider>.value(
            value: MockNavigationProvider(),
          ),
          ChangeNotifierProvider<WeightProvider>.value(
            value: mockWeightProvider,
          ),
        ],
        child: const MaterialApp(home: GoalSettingsScreen()),
      ),
    );

    // Enter target weight
    await tester.enterText(
      find.widgetWithText(TextField, 'Target Weight (lb)'),
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

    verify(
      mockGoalsProvider.saveSettings(
        any,
        isInitialSetup: anyNamed('isInitialSetup'),
      ),
    ).called(1);
  });
}
