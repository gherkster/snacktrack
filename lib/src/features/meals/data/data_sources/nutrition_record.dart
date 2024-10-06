class NutritionRecord {
  final String name;
  final String category;

  /// Kilojoules per 100g of food
  final int kilojoules;

  /// Protein in grams per 100g of food
  final double protein;

  NutritionRecord({required this.name, required this.category, required this.kilojoules, required this.protein});

  NutritionRecord.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        category = json["category"],
        kilojoules = json["kilojoules"],
        protein = json["protein"];

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "kilojoules": kilojoules,
      "protein": protein,
    };
  }
}
