import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/search_mode.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/widgets/search/search_mode_tabs.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'search_mode_tabs_test.mocks.dart';

@GenerateMocks([FoodSearchProvider])
void main() {
  late MockFoodSearchProvider mockProvider;

  setUp(() {
    mockProvider = MockFoodSearchProvider();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<FoodSearchProvider>.value(
          value: mockProvider,
          child: const SearchModeTabs(),
        ),
      ),
    );
  }

  testWidgets('displays all tabs', (tester) async {
    when(mockProvider.searchMode).thenReturn(SearchMode.text);

    await tester.pumpWidget(createTestWidget());

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
  });

  testWidgets('clicking a tab calls setSearchMode', (tester) async {
    when(mockProvider.searchMode).thenReturn(SearchMode.text);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.qr_code_scanner));
    verify(mockProvider.setSearchMode(SearchMode.scan)).called(1);

    await tester.tap(find.byIcon(Icons.restaurant_menu));
    verify(mockProvider.setSearchMode(SearchMode.recipe)).called(1);
  });
}
