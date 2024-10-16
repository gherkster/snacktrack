class Food {
  final int id;
  final String name;
  final String category;
  final double kilojoulesPer100g;
  final bool isCustom;
  final DateTime createdAt;
  final DateTime updatedAt;

  Food({
    this.id = 0,
    required this.name,
    required this.category,
    required this.kilojoulesPer100g,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
}
