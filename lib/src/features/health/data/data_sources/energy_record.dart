class EnergyRecord {
  final String externalId;
  final String name;

  /// Kilojoules per 100g of food
  final int kilojoules;

  /// Protein in grams per 100g of food
  final double protein;

  EnergyRecord({required this.externalId, required this.name, required this.kilojoules, required this.protein});

  EnergyRecord.fromJson(Map<String, dynamic> json)
      : externalId = json["externalId"],
        name = json["name"],
        kilojoules = json["kilojoules"],
        protein = json["protein"];

  Map<String, dynamic> toJson() {
    return {
      "externalId": externalId,
      "name": name,
      "kilojoules": kilojoules,
      "protein": protein,
    };
  }
}
