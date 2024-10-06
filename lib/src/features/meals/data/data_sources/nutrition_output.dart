import 'nutrition_record.dart';

class NutritionOutput {
  final List<NutritionRecord> records;
  final String hash;

  NutritionOutput({required this.records, required this.hash});

  NutritionOutput.fromJson(Map<String, dynamic> json)
      : records = (json["records"] as List).map((r) => NutritionRecord.fromJson(r)).toList(),
        hash = json["hash"];

  Map<String, dynamic> toJson() {
    return {
      "records": records,
      "hash": hash,
    };
  }
}
