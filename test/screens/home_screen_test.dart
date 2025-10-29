import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/screens/home_screen.dart';
import 'package:free_cal_counter1/screens/overview_screen.dart';
import 'package:free_cal_counter1/screens/log_screen.dart';
import 'package:free_cal_counter1/screens/weight_screen.dart';
import 'package:free_cal_counter1/screens/settings_screen.dart';

void main() {
  testWidgets('HomeScreen should display OverviewScreen initially', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NavigationProvider(),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.byType(OverviewScreen), findsOneWidget);
    expect(find.byType(LogScreen), findsNothing);
    expect(find.byType(WeightScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);
  });

  testWidgets('tapping bottom navigation bar items should switch screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NavigationProvider(),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.tap(find.byIcon(Icons.list));
    await tester.pump();

    expect(find.byType(OverviewScreen), findsNothing);
    expect(find.byType(LogScreen), findsOneWidget);
    expect(find.byType(WeightScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);

    await tester.tap(find.byIcon(Icons.monitor_weight));
    await tester.pump();

    expect(find.byType(OverviewScreen), findsNothing);
    expect(find.byType(LogScreen), findsNothing);
    expect(find.byType(WeightScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    expect(find.byType(OverviewScreen), findsNothing);
    expect(find.byType(LogScreen), findsNothing);
    expect(find.byType(WeightScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pump();

    expect(find.byType(OverviewScreen), findsOneWidget);
    expect(find.byType(LogScreen), findsNothing);
    expect(find.byType(WeightScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);
  });
}
