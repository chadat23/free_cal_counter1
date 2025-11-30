import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_router.dart';

import 'package:free_cal_counter1/widgets/discard_dialog.dart';
import 'package:free_cal_counter1/widgets/log_queue_top_ribbon.dart';
import 'package:free_cal_counter1/screens/serving_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/widgets/food_search_result_tile.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );

      if (navProvider.shouldFocusSearch) {
        _focusNode.requestFocus();
        navProvider.resetSearchFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            final logProvider = Provider.of<LogProvider>(
              context,
              listen: false,
            );
            final navProvider = Provider.of<NavigationProvider>(
              context,
              listen: false,
            );

            bool shouldPop = false;
            if (logProvider.logQueue.isNotEmpty) {
              final discard = await showDiscardDialog(context);
              if (discard == true) {
                logProvider.clearQueue();
                navProvider.goBack();
                shouldPop = true;
              }
            } else {
              navProvider.goBack();
              shouldPop = true;
            }

            if (shouldPop) {
              // Defer the pop operation to the next frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            }
          },
        ),
        title: Consumer<LogProvider>(
          builder: (context, logProvider, child) {
            return LogQueueTopRibbon(
              arrowDirection: Icons.arrow_drop_down,
              onArrowPressed: () {
                Navigator.pushNamed(context, AppRouter.logQueueRoute);
              },
              totalCalories: logProvider.totalCalories,
              dailyTargetCalories: logProvider.dailyTargetCalories,
              logQueue: logProvider.logQueue,
            );
          },
        ),
      ),
      body: Consumer<FoodSearchProvider>(
        builder: (context, foodSearchProvider, child) {
          if (foodSearchProvider.errorMessage != null) {
            return Center(
              child: Text(
                foodSearchProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (foodSearchProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (foodSearchProvider.searchResults.isEmpty) {
            return const Center(child: Text('Search for a food to begin'));
          }

          return ListView.builder(
            itemCount: foodSearchProvider.searchResults.length,
            itemBuilder: (context, index) {
              final food = foodSearchProvider.searchResults[index];
              return FoodSearchResultTile(
                key: ValueKey(food.id),
                food: food,
                onTap: (selectedUnit) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServingEditScreen(
                        food: food,
                        initialUnit: selectedUnit,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: FoodSearchRibbon(
        isSearchActive: true,
        focusNode: _focusNode,
        onChanged: (query) {
          if (query.isNotEmpty) {
            Provider.of<FoodSearchProvider>(
              context,
              listen: false,
            ).textSearch(query);
          } else {
            // Optionally clear results
          }
        },
        onOffSearch: () {
          Provider.of<FoodSearchProvider>(
            context,
            listen: false,
          ).performOffSearch();
        },
      ),
    );
  }
}
