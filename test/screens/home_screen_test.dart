import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('content respects SafeArea padding', (WidgetTester tester) async {
      const double topPadding = 50.0;

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: topPadding)),
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        ),
      );

      // Find the content that should be affected by SafeArea (the Center widget in HomeScreen's body)
      final Finder centerFinder = find.descendant(of: find.byType(SafeArea), matching: find.byType(Center));
      expect(centerFinder, findsOneWidget);

      // Get the render object of the Center widget
      final RenderBox renderBox = tester.renderObject(centerFinder);

      // Verify that the content's top is below the simulated padding
      // The SafeArea should push the content down by topPadding
      expect(renderBox.localToGlobal(Offset.zero).dy, greaterThanOrEqualTo(topPadding));
    });
  });
}