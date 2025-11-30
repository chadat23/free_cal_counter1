import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';

class FoodSearchRibbon extends StatefulWidget {
  final bool isSearchActive;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onOffSearch;

  const FoodSearchRibbon({
    super.key,
    this.isSearchActive = false,
    this.focusNode,
    this.onChanged,
    this.onOffSearch,
  });

  @override
  State<FoodSearchRibbon> createState() => _FoodSearchRibbonState();
}

class _FoodSearchRibbonState extends State<FoodSearchRibbon> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: widget.isSearchActive
                ? TextField(
                    focusNode: widget.focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search food...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                    ),
                    onChanged: widget.onChanged,
                  )
                : GestureDetector(
                    key: const Key('food_search_text_field'),
                    onTap: () {
                      Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      ).goToFoodSearch();
                      Navigator.pushNamed(context, AppRouter.foodSearchRoute);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Search food...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: widget.onOffSearch,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
            ),
            child: const Icon(Icons.language), // Globe icon
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Add button functionality
            },
            child: const Text('Log'),
          ),
        ],
      ),
    );
  }
}
