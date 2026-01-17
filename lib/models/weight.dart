class Weight {
  final int? id;
  final double weight;
  final DateTime date;
  final bool isFasted;

  Weight({
    this.id,
    required this.weight,
    required this.date,
    this.isFasted = false,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      id: json['id'] as int?,
      weight: (json['weight'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      isFasted: json['isFasted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'weight': weight,
      'date': date.millisecondsSinceEpoch,
      'isFasted': isFasted,
    };
  }
}
