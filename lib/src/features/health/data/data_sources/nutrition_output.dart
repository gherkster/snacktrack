import 'energy_record.dart';

class NutritionOutput {
  final List<EnergyRecord> records;

  NutritionOutput({required this.records});

  NutritionOutput.fromJson(Map<String, dynamic> json) : records = json["records"];

  Map<String, dynamic> toJson() {
    return {
      "records": records,
    };
  }
}
