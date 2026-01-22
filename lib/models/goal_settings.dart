enum GoalMode { gain, lose, maintain }

class GoalSettings {
  final double anchorWeight;
  final double maintenanceCaloriesStart;
  final double proteinTarget; // In grams
  final double fatTarget; // In grams
  final GoalMode mode;
  final double fixedDelta; // Used for gain/lose modes
  final DateTime lastTargetUpdate;
  final bool useMetric;
  final bool isSet;

  GoalSettings({
    required this.anchorWeight,
    required this.maintenanceCaloriesStart,
    required this.proteinTarget,
    required this.fatTarget,
    required this.mode,
    this.fixedDelta = 0.0,
    required this.lastTargetUpdate,
    this.useMetric = false,
    this.isSet = true,
  });

  factory GoalSettings.fromJson(Map<String, dynamic> json) {
    return GoalSettings(
      anchorWeight: (json['anchorWeight'] as num).toDouble(),
      maintenanceCaloriesStart: (json['maintenanceCaloriesStart'] as num)
          .toDouble(),
      proteinTarget: (json['proteinTarget'] as num).toDouble(),
      fatTarget: (json['fatTarget'] as num).toDouble(),
      mode: GoalMode.values.firstWhere(
        (e) => e.toString() == (json['mode'] as String),
        orElse: () => GoalMode.maintain,
      ),
      fixedDelta: (json['fixedDelta'] as num? ?? 0.0).toDouble(),
      lastTargetUpdate: DateTime.fromMillisecondsSinceEpoch(
        json['lastTargetUpdate'] as int? ?? 0,
      ),
      useMetric: json['useMetric'] as bool? ?? false,
      isSet:
          json['isSet'] as bool? ?? true, // Default to true for existing users
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anchorWeight': anchorWeight,
      'maintenanceCaloriesStart': maintenanceCaloriesStart,
      'proteinTarget': proteinTarget,
      'fatTarget': fatTarget,
      'mode': mode.toString(),
      'fixedDelta': fixedDelta,
      'lastTargetUpdate': lastTargetUpdate.millisecondsSinceEpoch,
      'useMetric': useMetric,
      'isSet': isSet,
    };
  }

  // Helper to create a default settings object
  factory GoalSettings.defaultSettings() {
    return GoalSettings(
      anchorWeight: 0.0,
      maintenanceCaloriesStart: 2000.0,
      proteinTarget: 150.0,
      fatTarget: 70.0,
      mode: GoalMode.maintain,
      fixedDelta: 0.0,
      lastTargetUpdate: DateTime(2000), // Far in the past to trigger update
      useMetric: false,
      isSet: false,
    );
  }
}
