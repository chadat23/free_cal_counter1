import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/screens/food_search_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('tapping search bar navigates to food search screen', (WidgetTester tester) async {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => LogProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(
            body: FoodSearchRibbon(),
          ),
          onGenerateRoute: (settings) {
            if (settings.name == AppRouter.foodSearchRoute) {
              return MaterialPageRoute(
                builder: (_) => const FoodSearchScreen(),
              );
            }
            return null;
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('food_search_text_field')));
    await tester.pumpAndSettle();

    expect(find.byType(FoodSearchScreen), findsOneWidget);
  });
}