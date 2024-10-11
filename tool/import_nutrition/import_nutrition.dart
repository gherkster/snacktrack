// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:excel/excel.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_record.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_output.dart';
import 'package:snacktrack/src/utilities/tokens.dart';

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

    // We are only interested in raw foods, cooked or fortified foods are ambiguous and overly wordy
    if (bannedTerms.any((term) => name.toLowerCase().contains(term))) {
      continue;
    }

    final (category, status) = switch (categories[classificationId.substring(0, 3)]) {
      (String cat, Action act) => (cat, act),
      _ => throw "Category does not exist for $name with classification ${classificationId.substring(0, 3)}"
    };

    if (status == Action.skip) {
      continue;
    }

    outputRows.add(
      NutritionRecord(
        externalId: externalId,
        name: name,
        category: category,
        kilojoules: kilojoules,
        protein: protein,
        tokens: tokenize(name),
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

enum Action {
  allow,
  skip,
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
  "steamed",
  "separable fat",
  "vitamin",
  "omega",
  "iron",
  "calcium",
  "fibre",
  "biscuit",
  "cereal",
  "slice",
  "cake",
  "confection",
  "reduced salt",
  "no added salt",
];

const Map<String, (String category, Action action)> categories = {
  "111": ("Tea", Action.allow),
  "112": ("Coffee", Action.allow),
  "113": ("Fruit and vegetable drinks", Action.allow),
  "114": ("Cordials", Action.allow),
  "115": ("Soft drinks and flavoured mineral waters", Action.allow),
  "116": ("Electrolyte, energy and fortified drinks", Action.allow),
  "117": ("Water", Action.allow),
  "118": ("Other beverages", Action.allow),
  "121": ("Flours and grains", Action.allow),
  "122": ("Bread", Action.allow),
  "123": ("Savoury and sweet breads", Action.allow),
  "124": ("Pasta", Action.allow),
  "125": ("Breakfast cereals", Action.skip),
  "126": ("Porridge", Action.skip),
  "131": ("Sweet biscuits", Action.skip),
  "132": ("Savoury biscuits", Action.skip),
  "133": ("Cakes, muffins and scones", Action.skip),
  "134": ("Pastries", Action.skip),
  "135": ("Mixed grain dishes", Action.skip),
  "136": ("Batter products", Action.skip),
  "141": ("Butter", Action.allow),
  "142": ("Dairy blends", Action.skip),
  "143": ("Margarine and spreads", Action.skip),
  "144": ("Plant oils", Action.allow),
  "145": ("Other fats", Action.allow),
  "146": ("Other fats", Action.allow),
  "151": ("Fish", Action.allow),
  "152": ("Crustacea and molluscs", Action.allow),
  "153": ("Other seafood", Action.allow),
  "154": ("Canned fish", Action.allow),
  "155": ("Fish and seafood products (homemade and takeaway)", Action.skip),
  "156": ("Mixed dishes with fish or seafood as the major component", Action.skip),
  "157": ("Wild caught fish and seafood", Action.skip),
  "160": ("Wild harvested fruits", Action.skip),
  "161": ("Fruit", Action.allow),
  "162": ("Fruit", Action.allow),
  "163": ("Fruit", Action.allow),
  "164": ("Fruit", Action.allow),
  "165": ("Fruit", Action.allow),
  "166": ("Fruit", Action.allow),
  "167": ("Mixtures of two or more groups of fruit", Action.skip),
  "168": ("Dried fruit", Action.allow),
  "169": ("Mixed dishes where fruit is the major component", Action.skip),
  "171": ("Eggs", Action.allow),
  "172": ("Dishes where egg is the major ingredient", Action.skip),
  "174": ("Wild harvested eggs", Action.skip),
  "180": ("Wild harvested meat, and meat dishes", Action.skip),
  "181": ("Beef, sheep and pork", Action.allow),
  "182": ("Game meats", Action.allow),
  "183": ("Poultry", Action.allow),
  "184": ("Offal", Action.allow),
  "185": ("Sausages", Action.allow),
  "186": ("Processed meats", Action.allow),
  "187": ("Mixed dishes where beef, sheep, pork or mammalian game is the major component", Action.skip),
  "188": ("Mixed dishes where sausage, bacon, ham or other processed meat is the major component", Action.skip),
  "189": ("Mixed dishes where poultry or feathered game is the major component", Action.skip),
  "191": ("Dairy milk", Action.allow),
  "192": ("Yoghurt", Action.allow),
  "193": ("Cream", Action.allow),
  "194": ("Cheese", Action.allow),
  "195": ("Frozen dairy", Action.allow),
  "196": ("Custard", Action.allow),
  "197": ("Other dishes where milk or a milk product is the major component", Action.skip),
  "198": ("Flavoured milks", Action.allow),
  "201": ("Dairy substitutes", Action.allow),
  "202": ("Dairy substitutes", Action.allow),
  "203": ("Dairy substitutes", Action.allow),
  "204": ("Dairy substitutes", Action.allow),
  "205": ("Dairy substitutes", Action.allow),
  "206": ("Meat substitutes", Action.allow),
  "207": ("Dishes where meat substitutes are the major component", Action.skip),
  "211": ("Soup, homemade from basic ingredients", Action.skip),
  "212": ("Dry soup mix", Action.skip),
  "213": ("Soup, prepared from dry soup mix", Action.skip),
  "214": ("Canned condensed soup (unprepared)", Action.skip),
  "215": ("Soup, commercially sterile, prepared from condensed or sold ready to heat", Action.skip),
  "216": ("Soup, not commercially sterile, purchased ready to eat", Action.skip),
  "221": ("Seeds", Action.allow),
  "222": ("Nuts", Action.allow),
  "223": ("Wild harvested seeds and nuts", Action.skip),
  "231": ("Gravies and savoury sauces", Action.skip),
  "232": ("Pickles and chutneys", Action.allow),
  "233": ("Salad dressings", Action.skip),
  "234": ("Stuffings", Action.skip),
  "235": ("Dips", Action.skip),
  "240": ("Wild harvested vegetables, and vegetable dishes", Action.skip),
  "241": ("Vegetables", Action.allow),
  "242": ("Vegetables", Action.allow),
  "243": ("Vegetables", Action.allow),
  "244": ("Vegetables", Action.allow),
  "245": ("Vegetables", Action.allow),
  "246": ("Vegetables", Action.allow),
  "247": ("Vegetables", Action.allow),
  "248": ("Other vegetables and vegetable combinations", Action.skip),
  "249": ("Dishes where vegetable is the major component", Action.skip),
  "251": ("Legumes and pulses", Action.allow),
  "252": ("Mature legume and pulse products and dishes", Action.skip),
  "261": ("Potato snacks", Action.skip),
  "262": ("Corn snacks", Action.skip),
  "263": ("Extruded or reformed snacks", Action.skip),
  "264": ("Other snacks", Action.skip),
  "271": ("Sugar, honey and syrups", Action.allow),
  "272": ("Jam and lemon spreads, chocolate spreads, sauces", Action.skip),
  "273": ("Dishes and products other than confectionery where sugar is the major component", Action.skip),
  "281": ("Chocolate and chocolate-based confectionery", Action.skip),
  "282": ("Fruit, nut and seed-bars", Action.skip),
  "283": ("Muesli or cereal style bars", Action.skip),
  "284": ("Other confectionery", Action.skip),
  "291": ("Beers", Action.allow),
  "292": ("Wines", Action.allow),
  "293": ("Spirits", Action.allow),
  "294": ("Cider", Action.allow),
  "295": ("Other alcoholic beverages", Action.skip),
  "301": ("Formula dietary foods", Action.allow),
  "311": ("Yeast, and yeast vegetable or meat extracts", Action.skip),
  "312": ("Intense sweetening agents", Action.skip),
  "313": ("Herbs, spices, seasonings and stock cubes", Action.allow),
  "314": ("Essences", Action.skip),
  "315": ("Raising agents and cooking ingredients", Action.allow),
  "321": ("Infant formulae and foods", Action.skip),
  "322": ("Infant foods", Action.skip),
  "323": ("Infant foods", Action.skip),
  "324": ("Infant drinks", Action.skip),
  "331": ("Vitamin and/or mineral supplements", Action.skip),
  "332": ("Oil supplements", Action.skip),
  "333": ("Herbal and homoeopathic supplements", Action.skip),
  "334": ("Other nutritive supplements", Action.skip),
  "335": ("Other non-nutritive supplements", Action.skip),
  "341": ("Reptiles", Action.skip),
  "342": ("Insects", Action.skip),
  "343": ("Amphibia", Action.skip),
};
