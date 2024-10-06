class Food {
  final int id;
  final String name;
  final String category;
  final double kilojoulesPerUnit;
  String unit;
  int quantity;
  final bool isCustom;
  final DateTime createdAt;
  final DateTime updatedAt;

  Food({
    this.id = 0,
    required this.name,
    required this.category,
    required this.kilojoulesPerUnit,
    required this.unit,
    required this.quantity,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
}
