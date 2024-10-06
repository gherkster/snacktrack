// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:excel/excel.dart';
import 'package:snacktrack/src/extensions/iterable.dart';
import 'package:snacktrack/src/features/health/domain/energy_unit.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_record.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_output.dart';
import 'package:snacktrack/src/utilities/unit_conversion.dart';

void main(List<String> arguments) {
  final dataRows = importDataset();
  saveOutput(dataRows);
}

List<NutritionRecord> importDataset() {
  var bytes = File("./datasets/dataset.xlsx").readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var dataSheet = excel.tables["foodstruct_nutritional_facts"];
  if (dataSheet == null) {
    throw const FormatException('Expected data sheet is missing');
  }

  print("${dataSheet.rows.length} rows found");
  final List<NutritionRecord> outputRows = [];

  for (var row in dataSheet.rows.skip(1)) {
    final name = (row[0]!.value as TextCellValue).value.text!;
    final category = (row[1]!.value as TextCellValue).value.text!;
    final calories = (row[3]!.value as IntCellValue).value;
    final proteinValue = row[20]!.value;

    // Skip irrelevant, potentially inaccurate or "meal" foods
    if (category
        .isIn(["Sweets", "Soups", "Baked Products", "Fast Foods", "Meals, Entrees, and Side Dishes", "Baby Foods"])) {
      continue;
    }

    var protein = 0.0;
    switch (proteinValue) {
      case IntCellValue():
        protein = proteinValue.value.toDouble();
      case DoubleCellValue():
        protein = proteinValue.value;
      default:
        throw "Invalid format for protein value";
    }

    outputRows.add(
      NutritionRecord(
        name: name,
        category: category,
        kilojoules: convertEnergyToKilojoules(calories, EnergyUnit.calories).round(),
        protein: protein,
      ),
    );
  }

  return outputRows;
}

void saveOutput(List<NutritionRecord> records) {
  final hash = md5.convert(utf8.encode(jsonEncode(records))).toString();
  final output = NutritionOutput(records: records, hash: hash);

  final file = File("../../assets/nutrition.json");
  file.createSync(recursive: true);
  file.writeAsString(jsonEncode(output));

  print("Wrote ${records.length} records to ${file.path}. Document hash $hash.");
}
