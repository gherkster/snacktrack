// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:excel/excel.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_record.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_output.dart';

void main(List<String> arguments) {
  final dataRows = importDataset();
  saveOutput(dataRows);
}

List<NutritionRecord> importDataset() {
  var bytes = File("./datasets/dataset.xlsx").readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var dataSheet = excel.tables["All solids & liquids per 100g"];
  if (dataSheet == null) {
    throw const FormatException("Expected data sheet is missing");
  }

  print("${dataSheet.rows.length} rows found");
  final List<NutritionRecord> outputRows = [];

  for (var row in dataSheet.rows.skip(1)) {
    final externalId = (row[0]!.value as TextCellValue).value.text!;
    final classificationIdValue = row[1]!.value;
    final name = (row[2]!.value as TextCellValue).value.text!;
    const category = ""; // TODO: Not implemented yet, needs to be generated based on classification
    final kilojoules = (row[3]!.value as IntCellValue).value;
    final proteinValue = row[6]!.value;

    if (classificationIdValue == null) {
      // Only F009834 is missing a classification and would be filtered out later anyway
      continue;
    }

    String classificationId = "";
    switch (classificationIdValue) {
      case IntCellValue():
        classificationId = classificationIdValue.value.toString();
      case TextCellValue():
        classificationId = classificationIdValue.value.text!;
      default:
        throw "Invalid format for $name classification ID";
    }

    var protein = 0.0;
    switch (proteinValue) {
      case IntCellValue():
        protein = proteinValue.value.toDouble();
      case DoubleCellValue():
        protein = proteinValue.value;
      default:
        throw "Invalid format for $name protein value";
    }

    const bannedTerms = [
      "cooked",
      "fried",
      "boiled",
      "poached",
      "scrambled",
      "grilled",
      "roasted",
      "baked",
      "stewed",
      "braised",
      "toasted",
      "microwaved",
      "casserole",
      "smoked",
      "separable fat",
      "vitamin",
      "omega",
      "iron",
      "calcium",
      "fibre"
    ];

    // We are only interested in raw foods, cooked or fortified foods are ambiguous and overly wordy
    if (bannedTerms.any((term) => name.toLowerCase().contains(term))) {
      continue;
    }

    const Map<String, String> bannedCategories = {
      "11805": "Breakfast cereal beverages",
      "12501": "Breakfast cereal, corn based",
      "12502": "Breakfast cereal, corn based, fortified",
      "12503": "Breakfast cereal, rice based",
      "12504": "Breakfast cereal, rice based, fortified",
      "12505": "Breakfast cereal, wheat based",
      "12506": "Breakfast cereal, wheat based, fortified, sugars <=20 g/100g",
      "12509": "Breakfast cereal, wheat based, with fruit and/or nuts, fortified, sugars <=25 g/100g",
      "12511": "Breakfast cereal, mixed grain",
      "12512": "Breakfast cereal, mixed grain, fortified, sugars <=20 g/100g",
      "12513": "Breakfast cereal, mixed grain, fortified, sugars >20 g/100g",
      "12515": "Breakfast cereal, mixed grain, with fruit and/or nuts, fortified",
      "13106": "Sweet biscuits, chocolate-coated, chocolate or cream filled",
      "13202": "Savoury biscuits, wheat based, plain, energy >1800 kJ per 100 g",
      "13301": "Cakes and cake mixes, chocolate",
      "13303": "Cakes and cake mixes, other types",
      "13306": "Slices, biscuit and cake-type",
      "13405": "Savoury pastry products, pies, rolls and envelopes",
      "13501": "Pizza, saturated fat <=5 g/100 g",
      "13505": "Burgers, saturated fat <=5 g/100 g",
      "13506": "Burgers, saturated fat >5 g/100 g",
      "13509": "Savoury pasta/noodle and sauce dishes, saturated fat <=5 g/100 g",
      "13601": "Pancakes, crepes and dishes",
      "32102": "Human breast milk",
    };

    if (bannedCategories.containsKey(classificationId)) {
      continue;
    }

    const Map<int, String> categories = {};

    outputRows.add(
      NutritionRecord(
        externalId: externalId,
        name: name,
        category: category,
        kilojoules: kilojoules,
        protein: protein,
      ),
    );
  }

  return outputRows;
}

void saveOutput(List<NutritionRecord> records) {
  final hash = md5.convert(utf8.encode(jsonEncode(records))).toString();
  final nutritionHashFile = File("../../assets/nutrition-hash.txt");
  nutritionHashFile.createSync(recursive: true);
  nutritionHashFile.writeAsStringSync(hash);

  final output = NutritionOutput(records: records);
  final nutritionFile = File("../../assets/nutrition.json");
  nutritionFile.createSync(recursive: true);
  nutritionFile.writeAsStringSync(jsonEncode(output));

  print("Wrote ${records.length} records to ${nutritionFile.path}. Document hash $hash.");
}
