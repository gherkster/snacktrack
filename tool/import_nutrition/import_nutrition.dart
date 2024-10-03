// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:snacktrack/src/features/health/data/data_sources/energy_record.dart';
import 'package:snacktrack/src/features/health/data/data_sources/nutrition_output.dart';

void main(List<String> arguments) {
  final dataRows = importDataset();
  saveOutput(dataRows);
}

List<EnergyRecord> importDataset() {
  var bytes = File("./datasets/dataset.xlsx").readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var dataSheet = excel.tables["All solids & liquids per 100g"];
  if (dataSheet == null) {
    throw const FormatException('Expected data sheet is missing');
  }

  print("${dataSheet.rows.length} rows found");
  final List<EnergyRecord> outputRows = [];

  for (var row in dataSheet.rows.skip(1)) {
    final externalId = (row[0]!.value as TextCellValue).value.text!;
    final name = (row[2]!.value as TextCellValue).value.text!;
    final kilojoules = (row[3]!.value as IntCellValue).value;
    final proteinValue = row[6]!.value;

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
      EnergyRecord(externalId: externalId, name: name, kilojoules: kilojoules, protein: protein),
    );
  }

  return outputRows;
}

void saveOutput(List<EnergyRecord> records) {
  final output = NutritionOutput(records: records);

  final file = File("../../assets/nutrition.json");
  file.createSync(recursive: true);
  file.writeAsString(jsonEncode(output));

  print("Wrote ${records.length} records to ${file.path}");
}
