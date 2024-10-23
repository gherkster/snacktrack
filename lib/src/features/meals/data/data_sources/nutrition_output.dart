import "nutrition_record.dart";

class NutritionOutput {
  final List<NutritionRecord> records;

  NutritionOutput({required this.records});

  NutritionOutput.fromJson(Map<String, dynamic> json)
      : records = (json["records"] as List).map((r) => NutritionRecord.fromJson(r)).toList();

  Map<String, dynamic> toJson() {
    return {
      "records": records,
    };
  }
}
