import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';

import 'package:free_cal_counter1/utils/math_evaluator.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final _weightController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus for the text field after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitWeight() {
    final weight = MathEvaluator.evaluate(_weightController.text);
    if (weight != null) {
      // TODO: Save the weight
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Weight saved: $weight')));
    }
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: 120.0, // Adjust width to fit 4 digits + decimal point
                child: TextField(
                  controller: _weightController,
                  focusNode: _focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _submitWeight(),
                  onTap: () {
                    _weightController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _weightController.text.length,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitWeight,
                child: const Text('Enter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
