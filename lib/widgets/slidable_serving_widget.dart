import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/widgets/serving_widget.dart';

class SlidableServingWidget extends StatelessWidget {
  final FoodPortion serving;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const SlidableServingWidget({
    super.key,
    required this.serving,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // The key is important for Slidable to close other items when one is opened
      key: key ?? ValueKey(serving),
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
        child: ServingWidget(serving: serving, onEdit: onEdit),
      ),
    );
  }
}
