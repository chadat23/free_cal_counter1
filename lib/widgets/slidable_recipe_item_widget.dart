import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:free_cal_counter1/models/recipe_item.dart';
import 'package:free_cal_counter1/widgets/recipe_item_widget.dart';

class SlidableRecipeItemWidget extends StatelessWidget {
  final RecipeItem item;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const SlidableRecipeItemWidget({
    super.key,
    required this.item,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        color: Theme.of(context).canvasColor,
        child: RecipeItemWidget(item: item, onEdit: onEdit),
      ),
    );
  }
}
