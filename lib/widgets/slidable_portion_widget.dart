import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/widgets/portion_widget.dart';

class SlidablePortionWidget extends StatefulWidget {
  final FoodPortion portion;
  final VoidCallback onDelete;

  const SlidablePortionWidget({
    super.key,
    required this.portion,
    required this.onDelete,
  });

  @override
  State<SlidablePortionWidget> createState() => _SlidablePortionWidgetState();
}

class _SlidablePortionWidgetState extends State<SlidablePortionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late FocusNode _focusNode;
  final double _slideDistance = 80.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta! / _slideDistance;
    _controller.value -= delta;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.forward();
      _focusNode.requestFocus();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    widget.onDelete();
                    _controller.reverse();
                  },
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-_controller.value * _slideDistance, 0),
                  child: child,
                );
              },
              child: GestureDetector(
                key: const Key('slidable_portion_content'),
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (_controller.isCompleted) {
                    _controller.reverse();
                  }
                },
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: PortionWidget(portion: widget.portion),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}