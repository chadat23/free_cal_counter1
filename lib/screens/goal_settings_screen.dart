import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/goal_settings.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/utils/ui_utils.dart';

class GoalSettingsScreen extends StatefulWidget {
  const GoalSettingsScreen({super.key});

  @override
  State<GoalSettingsScreen> createState() => _GoalSettingsScreenState();
}

class _GoalSettingsScreenState extends State<GoalSettingsScreen> {
  late TextEditingController _anchorWeightController;
  late TextEditingController _maintenanceCalController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _fiberController;
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
    _fiberController = TextEditingController(
      text: settings.fiberTarget.toString(),
    );
    _fixedDeltaController = TextEditingController(
      text: settings.fixedDelta.toString(),
    );
    _mode = settings.mode;
    _useMetric = settings.useMetric;
  }

  @override
  void dispose() {
    _anchorWeightController.dispose();
    _maintenanceCalController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _fixedDeltaController.dispose();
    super.dispose();
  }

  void _save() {
    // Validate required fields
    final maintenanceCal = double.tryParse(_maintenanceCalController.text);
    if (maintenanceCal == null || maintenanceCal <= 0) {
      UiUtils.showAutoDismissDialog(
        context,
        'Please enter valid maintenance calories',
      );
      return;
    }

    final protein = double.tryParse(_proteinController.text);
    if (protein == null || protein <= 0) {
      UiUtils.showAutoDismissDialog(
        context,
        'Please enter valid protein target',
      );
      return;
    }

    final fat = double.tryParse(_fatController.text);
    if (fat == null || fat <= 0) {
      UiUtils.showAutoDismissDialog(context, 'Please enter valid fat target');
      return;
    }

    final fiber = double.tryParse(_fiberController.text);
    if (fiber == null || fiber <= 0) {
      UiUtils.showAutoDismissDialog(context, 'Please enter valid fiber target');
      return;
    }

    // For maintain mode, validate target weight
    double? targetWeight;
    if (_mode == GoalMode.maintain) {
      targetWeight = double.tryParse(_anchorWeightController.text);
      if (targetWeight == null || targetWeight <= 0) {
        UiUtils.showAutoDismissDialog(
          context,
          'Please enter a valid target weight',
        );
        return;
      }
    }

    // For lose/gain modes, validate delta
    double? delta;
    if (_mode != GoalMode.maintain) {
      delta = double.tryParse(_fixedDeltaController.text);
      if (delta == null || delta <= 0) {
        UiUtils.showAutoDismissDialog(context, 'Please enter a valid delta');
        return;
      }
    }

    // Detect if this is initial setup
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final isInitialSetup = !goalsProvider.isGoalsSet;

    final newSettings = GoalSettings(
      anchorWeight: _mode == GoalMode.maintain
          ? targetWeight!
          : 0.0, // No anchor weight needed for lose/gain
      maintenanceCaloriesStart: maintenanceCal,
      proteinTarget: protein,
      fatTarget: fat,
      fiberTarget: fiber,
      mode: _mode,
      fixedDelta: _mode != GoalMode.maintain ? delta! : 0.0,
      lastTargetUpdate: goalsProvider.settings.lastTargetUpdate,
      useMetric: _useMetric,
      isSet: true,
    );

    goalsProvider.saveSettings(newSettings, isInitialSetup: isInitialSetup);
    Navigator.pop(context);

    // Switch to Overview tab so Overview will reload when user navigates back
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.changeTab(0);

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
          if (_mode == GoalMode.maintain)
            _buildTextField(
              controller: _anchorWeightController,
              label: 'Target Weight (${_useMetric ? 'kg' : 'lb'})',
              hint: 'Your target weight',
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
          _buildTextField(
            controller: _fiberController,
            label: 'Fiber (g)',
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
