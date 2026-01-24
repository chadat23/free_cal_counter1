import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/screens/goal_settings_screen.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/models/goal_settings.dart';
import 'package:free_cal_counter1/providers/weight_provider.dart';

import 'onboarding_navigation_test.mocks.dart';

@GenerateMocks([GoalsProvider, NavigationProvider, WeightProvider])
void main() {
  late MockGoalsProvider mockGoalsProvider;
  late MockNavigationProvider mockNavigationProvider;
  late MockWeightProvider mockWeightProvider;

  setUp(() {
    mockGoalsProvider = MockGoalsProvider();
    mockNavigationProvider = MockNavigationProvider();
    mockWeightProvider = MockWeightProvider();

    when(mockGoalsProvider.settings).thenReturn(GoalSettings.defaultSettings());
    when(mockGoalsProvider.isGoalsSet).thenReturn(false);
    when(
      mockGoalsProvider.saveSettings(
        any,
        isInitialSetup: anyNamed('isInitialSetup'),
      ),
    ).thenAnswer((_) async {});
    when(mockWeightProvider.getWeightForDate(any)).thenReturn(null);
  });

  testWidgets('Saving initial goals should return to Overview screen (tab 0)', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalsProvider>.value(value: mockGoalsProvider),
          ChangeNotifierProvider<NavigationProvider>.value(
            value: mockNavigationProvider,
          ),
          ChangeNotifierProvider<WeightProvider>.value(
            value: mockWeightProvider,
          ),
        ],
        child: const MaterialApp(home: GoalSettingsScreen()),
      ),
    );

    // Enter target weight
    final weightField = find.widgetWithText(TextField, 'Target Weight (lb)');
    await tester.scrollUntilVisible(
      weightField,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(weightField, '150');

    // Enter maintenance calories
    final maintenanceField = find.widgetWithText(
      TextField,
      'Initial Maintenance Calories',
    );
    await tester.scrollUntilVisible(
      maintenanceField,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(maintenanceField, '2340');

    // Enter protein
    final proteinField = find.widgetWithText(TextField, 'Protein (g)');
    await tester.scrollUntilVisible(
      proteinField,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(proteinField, '150');

    // Enter fat
    final fatField = find.widgetWithText(TextField, 'Fat (g)');
    await tester.scrollUntilVisible(
      fatField,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(fatField, '70');

    // Enter fiber
    final fiberField = find.widgetWithText(TextField, 'Fiber (g)');
    await tester.scrollUntilVisible(
      fiberField,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(fiberField, '38');

    // Scroll to save button
    final saveButton = find.text('Save Settings');
    await tester.scrollUntilVisible(
      saveButton,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify it navigates to tab 0 (Overview), not tab 1 (Log)
    verify(mockNavigationProvider.changeTab(0)).called(1);
    verifyNever(mockNavigationProvider.changeTab(1));
  });
}
