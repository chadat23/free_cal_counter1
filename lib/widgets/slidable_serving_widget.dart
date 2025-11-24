import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/widgets/serving_widget.dart';

class SlidableServingWidget extends StatefulWidget {
  final FoodPortion serving;
  final VoidCallback onDelete;

  const SlidableServingWidget({
    super.key,
    required this.serving,
    required this.onDelete,
  });

  @override
  State<SlidableServingWidget> createState() => _SlidableServingWidgetState();
}

class _SlidableServingWidgetState extends State<SlidableServingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0.0;
  final double _maxDragExtent = 100.0; // Width of the delete button area

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      // Clamp drag extent between -_maxDragExtent and 0
      if (_dragExtent > 0) _dragExtent = 0;
      if (_dragExtent < -_maxDragExtent) _dragExtent = -_maxDragExtent;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragExtent < -_maxDragExtent / 2) {
      // Snap open
      setState(() {
        _dragExtent = -_maxDragExtent;
      });
    } else {
      // Snap closed
      setState(() {
        _dragExtent = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background (Delete Button)
        Positioned.fill(
          child: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: widget.onDelete,
            ),
          ),
        ),
        // Foreground (Content)
        Transform.translate(
          offset: Offset(_dragExtent, 0),
          child: GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: Container(
              color: Theme.of(context).canvasColor, // Ensure opaque background
              child: ServingWidget(serving: widget.serving),
            ),
          ),
        ),
      ],
    );
  }
}
