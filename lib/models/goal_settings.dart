enum GoalMode { gain, lose, maintain }

class GoalSettings {
  final double anchorWeight;
  final double maintenanceCaloriesStart;
  final double proteinTarget; // In grams
  final double fatTarget; // In grams
  final double fiberTarget; // In grams
  final GoalMode mode;
  final double fixedDelta; // Used for gain/lose modes
  final DateTime lastTargetUpdate;
  final bool useMetric;
  final bool isSet;
  final int tdeeWindowDays;

  GoalSettings({
    required this.anchorWeight,
    required this.maintenanceCaloriesStart,
    required this.proteinTarget,
    required this.fatTarget,
    required this.fiberTarget,
    required this.mode,
    this.fixedDelta = 0.0,
    required this.lastTargetUpdate,
    this.useMetric = false,
    this.isSet = true,
    this.tdeeWindowDays = 30,
  });

  factory GoalSettings.fromJson(Map<String, dynamic> json) {
    return GoalSettings(
      anchorWeight: (json['anchorWeight'] as num).toDouble(),
      maintenanceCaloriesStart: (json['maintenanceCaloriesStart'] as num)
          .toDouble(),
      proteinTarget: (json['proteinTarget'] as num).toDouble(),
      fatTarget: (json['fatTarget'] as num).toDouble(),
      fiberTarget: (json['fiberTarget'] as num).toDouble(),
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
      tdeeWindowDays: json['tdeeWindowDays'] as int? ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anchorWeight': anchorWeight,
      'maintenanceCaloriesStart': maintenanceCaloriesStart,
      'proteinTarget': proteinTarget,
      'fatTarget': fatTarget,
      'fiberTarget': fiberTarget,
      'mode': mode.toString(),
      'fixedDelta': fixedDelta,
      'lastTargetUpdate': lastTargetUpdate.millisecondsSinceEpoch,
      'useMetric': useMetric,
      'isSet': isSet,
      'tdeeWindowDays': tdeeWindowDays,
    };
  }

  // Helper to create a default settings object
  factory GoalSettings.defaultSettings() {
    return GoalSettings(
      anchorWeight: 0.0,
      maintenanceCaloriesStart: 2000.0,
      proteinTarget: 150.0,
      fatTarget: 70.0,
      fiberTarget: 38.0,
      mode: GoalMode.maintain,
      fixedDelta: 0.0,
      lastTargetUpdate: DateTime(2000), // Far in the past to trigger update
      useMetric: false,
      isSet: false,
      tdeeWindowDays: 30,
    );
  }

  // Helper to create a copy with some fields changed
  GoalSettings copyWith({
    double? anchorWeight,
    double? maintenanceCaloriesStart,
    double? proteinTarget,
    double? fatTarget,
    double? fiberTarget,
    GoalMode? mode,
    double? fixedDelta,
    DateTime? lastTargetUpdate,
    bool? useMetric,
    bool? isSet,
    int? tdeeWindowDays,
  }) {
    return GoalSettings(
      anchorWeight: anchorWeight ?? this.anchorWeight,
      maintenanceCaloriesStart:
          maintenanceCaloriesStart ?? this.maintenanceCaloriesStart,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      fatTarget: fatTarget ?? this.fatTarget,
      fiberTarget: fiberTarget ?? this.fiberTarget,
      mode: mode ?? this.mode,
      fixedDelta: fixedDelta ?? this.fixedDelta,
      lastTargetUpdate: lastTargetUpdate ?? this.lastTargetUpdate,
      useMetric: useMetric ?? this.useMetric,
      isSet: isSet ?? this.isSet,
      tdeeWindowDays: tdeeWindowDays ?? this.tdeeWindowDays,
    );
  }
}
