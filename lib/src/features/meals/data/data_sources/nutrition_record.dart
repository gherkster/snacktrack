class NutritionRecord {
  final String externalId;
  final String name;
  final String category;
  final List<String> tokens;

  /// Kilojoules per 100g of food
  final int kilojoules;

  /// Protein in grams per 100g of food
  final double protein;

  NutritionRecord({
    required this.externalId,
    required this.name,
    required this.category,
    required this.kilojoules,
    required this.protein,
    required this.tokens,
  });

  NutritionRecord.fromJson(Map<String, dynamic> json)
      : externalId = json["externalId"],
        name = json["name"],
        category = json["category"],
        kilojoules = json["kilojoules"],
        protein = json["protein"],
        tokens = (json["tokens"] as List).map((t) => t.toString()).toList();

  Map<String, dynamic> toJson() {
    return {
      "externalId": externalId,
      "name": name,
      "category": category,
      "kilojoules": kilojoules,
      "protein": protein,
      "tokens": tokens,
    };
  }
}
