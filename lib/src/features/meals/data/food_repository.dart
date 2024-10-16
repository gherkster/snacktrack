import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:fuzzywuzzy/algorithms/weighted_ratio.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:snacktrack/objectbox.g.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_output.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_record.dart';
import 'package:snacktrack/src/features/meals/data/models/food_dto.dart';
import 'package:snacktrack/src/features/meals/data/models/token_dto.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/utilities/tokens.dart';

class FoodRepository {
  final Store store;
  final Box<FoodDto> _box;

  FoodRepository(this.store) : _box = store.box<FoodDto>();

  Future<List<Food>> searchFoods(String queryText, [int limit = 10]) async {
    // Limit the number of tokens so that performance is not impacted by excessive search conditions
    final queryTokens = tokenize(queryText).take(5).toList();
    final queryBuilder = _box.query();

    // Perform a startsWith search on each token linked to a food item,
    // to retrieve any food items that contain one of the search tokens
    for (final token in queryTokens) {
      queryBuilder.linkMany(FoodDto_.tokens, TokenDto_.text.startsWith(token, caseSensitive: false));
    }

    final query = queryBuilder.build();
    query.limit = limit;

    final results = await query.findAsync();
    query.close();

    var sortedResults = extractAllSorted(
      query: queryText,
      choices: results,
      getter: (food) => food.name,
      ratio: const WeightedRatio(),
    );

    return sortedResults.map((r) => r.choice.mapToDomain()).toList();
  }

  int count() => _box.count();

  Future<String> getLatestDatabaseHash() async {
    return await rootBundle.loadString("assets/nutrition-hash.txt");
  }

  Future<void> loadDatasetFoods() async {
    final json = await rootBundle.loadString("assets/nutrition.json");
    final map = jsonDecode(json);
    final dataset = NutritionOutput.fromJson(map);

    final nutritionRecords = dataset.records.map((r) => r.mapToDto()).toList();

    store.runInTransaction(TxMode.write, () {
      // Remove all stored dataset foods
      _box.query(FoodDto_.isCustom.equals(false)).build().remove();
      // Insert all dataset foods
      _box.putMany(nutritionRecords, mode: PutMode.insert);
    });
    log("Refreshed the food database with ${nutritionRecords.length} foods");
  }
}

extension FoodMapping on FoodDto {
  Food mapToDomain() {
    return Food(
      id: id,
      name: name,
      category: category,
      kilojoulesPer100g: kilojoulesPer100g,
      isCustom: isCustom,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension NutritionMapping on NutritionRecord {
  FoodDto mapToDto() {
    final now = DateTime.now();
    final dto = FoodDto(
      name: name,
      category: category,
      kilojoulesPer100g: kilojoules.toDouble(),
      proteinPerUnit: protein,
      isCustom: false,
      createdAt: now,
      updatedAt: now,
    );
    dto.tokens.addAll(tokens.map((t) => TokenDto(text: t)));
    return dto;
  }
}
