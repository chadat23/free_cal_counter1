import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/goal_settings.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:free_cal_counter1/providers/weight_provider.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/utils/ui_utils.dart';

class GoalSettingsScreen extends StatefulWidget {
  const GoalSettingsScreen({super.key});

  @override
  State<GoalSettingsScreen> createState() => _GoalSettingsScreenState();
}

class _GoalSettingsScreenState extends State<GoalSettingsScreen> {
  late TextEditingController _currentWeightController;
  late TextEditingController _anchorWeightController;
  late TextEditingController _maintenanceCalController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _fixedDeltaController;
  late GoalMode _mode;
  late bool _useMetric;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<GoalsProvider>(
      context,
      listen: false,
    ).settings;

    final weightProvider = Provider.of<WeightProvider>(context, listen: false);
    final todayWeight = weightProvider.getWeightForDate(DateTime.now())?.weight;

    _currentWeightController = TextEditingController(
      text: (todayWeight ?? settings.anchorWeight).toString(),
    );
    _anchorWeightController = TextEditingController(
      text: settings.anchorWeight.toString(),
    );
    _maintenanceCalController = TextEditingController(
      text: settings.maintenanceCaloriesStart.toString(),
    );
    _proteinController = TextEditingController(
      text: settings.proteinTarget.toString(),
    );
    _fatController = TextEditingController(text: settings.fatTarget.toString());
    _fixedDeltaController = TextEditingController(
      text: settings.fixedDelta.toString(),
    );
    _mode = settings.mode;
    _useMetric = settings.useMetric;
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _anchorWeightController.dispose();
    _maintenanceCalController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _fixedDeltaController.dispose();
    super.dispose();
  }

  void _save() {
    // Save current weight first so it's available for calculation
    final currentWeight = double.tryParse(_currentWeightController.text);
    if (currentWeight != null) {
      Provider.of<WeightProvider>(
        context,
        listen: false,
      ).saveWeight(currentWeight, DateTime.now());
    }

    final newSettings = GoalSettings(
      anchorWeight: double.tryParse(_anchorWeightController.text) ?? 0.0,
      maintenanceCaloriesStart:
          double.tryParse(_maintenanceCalController.text) ?? 2000.0,
      proteinTarget: double.tryParse(_proteinController.text) ?? 150.0,
      fatTarget: double.tryParse(_fatController.text) ?? 70.0,
      mode: _mode,
      fixedDelta: double.tryParse(_fixedDeltaController.text) ?? 0.0,
      lastTargetUpdate: Provider.of<GoalsProvider>(
        context,
        listen: false,
      ).settings.lastTargetUpdate,
      useMetric: _useMetric,
      isSet: true, // Mark as set on save (handling upgrade from null)
    );

    Provider.of<GoalsProvider>(
      context,
      listen: false,
    ).saveSettings(newSettings);
    Navigator.pop(context);
    UiUtils.showAutoDismissDialog(context, 'Goal settings saved');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: AppBar(
        title: const Text('Goals & Targets'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Goal Mode',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildModeSelector(),
          const Divider(height: 40),
          _buildTextField(
            controller: _currentWeightController,
            label: 'Current Weight (${_useMetric ? 'kg' : 'lb'})',
            hint: 'Your weight today',
          ),
          _buildTextField(
            controller: _anchorWeightController,
            label: 'Anchor Weight (${_useMetric ? 'kg' : 'lb'})',
            hint: 'Your target or baseline weight',
          ),
          SwitchListTile(
            title: const Text('Use Metric Units (kg)'),
            subtitle: const Text('Affects calorie drift calculation'),
            value: _useMetric,
            onChanged: (val) => setState(() => _useMetric = val),
          ),
          _buildTextField(
            controller: _maintenanceCalController,
            label: 'Initial Maintenance Calories',
            hint: 'Your estimated TDEE',
            keyboardType: TextInputType.number,
          ),
          if (_mode != GoalMode.maintain)
            _buildTextField(
              controller: _fixedDeltaController,
              label: _mode == GoalMode.gain ? 'Gain Delta' : 'Lose Delta',
              hint: 'e.g. 500',
              keyboardType: TextInputType.number,
            ),
          const Divider(height: 40),
          const Text(
            'Macro Split (Fixed)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _proteinController,
            label: 'Protein (g)',
            keyboardType: TextInputType.number,
          ),
          _buildTextField(
            controller: _fatController,
            label: 'Fat (g)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return SegmentedButton<GoalMode>(
      segments: const [
        ButtonSegment(value: GoalMode.lose, label: Text('Lose')),
        ButtonSegment(value: GoalMode.maintain, label: Text('Maintain')),
        ButtonSegment(value: GoalMode.gain, label: Text('Gain')),
      ],
      selected: {_mode},
      onSelectionChanged: (newSelection) {
        setState(() {
          _mode = newSelection.first;
        });
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = const TextInputType.numberWithOptions(
      decimal: true,
    ),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
