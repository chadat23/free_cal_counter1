class FoodUsageStats {
  final int foodId;
  final int logCount;
  final DateTime? lastLoggedAt;
  final List<DateTime> logTimestamps;

  FoodUsageStats({
    required this.foodId,
    required this.logCount,
    this.lastLoggedAt,
    required this.logTimestamps,
  });

  /// Number of days since this food was last logged
  /// Returns a large number if never logged
  int get daysSinceLastLogged {
    if (lastLoggedAt == null) return 999999;
    return DateTime.now().difference(lastLoggedAt!).inDays;
  }

  /// Typical hour of day when this food is logged
  /// Returns median hour from all log timestamps
  int get typicalHour {
    if (logTimestamps.isEmpty) return 12;
    final hours = logTimestamps.map((t) => t.hour).toList();
    hours.sort();
    return hours[hours.length ~/ 2]; // Median hour
  }
}
