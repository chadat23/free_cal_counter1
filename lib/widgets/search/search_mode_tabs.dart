import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/search_mode.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';

class SearchModeTabs extends StatelessWidget {
  const SearchModeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodSearchProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTab(
                context,
                provider,
                SearchMode.text,
                'Text',
                Icons.search,
              ),
              _buildTab(
                context,
                provider,
                SearchMode.scan,
                'Scan',
                Icons.qr_code_scanner,
              ),
              _buildTab(
                context,
                provider,
                SearchMode.recipe,
                'Recipe',
                Icons.restaurant_menu,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context,
    FoodSearchProvider provider,
    SearchMode mode,
    String label,
    IconData icon,
  ) {
    final isSelected = provider.searchMode == mode;
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return GestureDetector(
      onTap: () => provider.setSearchMode(mode),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: color,
            ),
        ],
      ),
    );
  }
}
