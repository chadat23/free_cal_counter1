class FoodContainer {
  final int id;
  final String name;
  final double weight;
  final String unit;
  final String? thumbnail;
  final bool hidden;

  FoodContainer({
    required this.id,
    required this.name,
    required this.weight,
    required this.unit,
    this.thumbnail,
    this.hidden = false,
  });

  FoodContainer copyWith({
    int? id,
    String? name,
    double? weight,
    String? unit,
    String? thumbnail,
    bool? hidden,
  }) {
    return FoodContainer(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      thumbnail: thumbnail ?? this.thumbnail,
      hidden: hidden ?? this.hidden,
    );
  }

  // Helper to check if thumbnail is local is handled by ImageStorageService
  // but we can add helper here if needed similar to Food model
  // keeping it simple for now as per plan
}
