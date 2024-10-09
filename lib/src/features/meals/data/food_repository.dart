import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:snacktrack/objectbox.g.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_output.dart';
import 'package:snacktrack/src/features/meals/data/data_sources/nutrition_record.dart';
import 'package:snacktrack/src/features/meals/data/models/food_dto.dart';
import 'package:snacktrack/src/features/meals/data/models/token_dto.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/utilities/tokens.dart';

class FoodRepository {
  final Box<FoodDto> _box;

  FoodRepository(this._box);

  Future<List<Food>> searchFoods(String queryText, [int limit = 10]) async {
    // TODO: Limit the number of tokens for performance?
    final queryTokens = tokenize(queryText);
    final queryBuilder = _box.query();

    // Perform a substring search on each token linked to a food item
    for (final token in queryTokens) {
      queryBuilder.linkMany(FoodDto_.tokens, TokenDto_.text.contains(token, caseSensitive: false));
    }

    final query = queryBuilder.build();
    query.limit = limit;

    final results = await query.findAsync();
    query.close();
    return results.map((r) => r.mapToDomain()).toList();
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

    // TODO: Run in transaction
    // Remove all stored dataset foods
    await _box.query(FoodDto_.isCustom.equals(false)).build().removeAsync();
    // Insert all dataset foods
    await _box.putManyAsync(nutritionRecords, mode: PutMode.insert);
  }
}

extension FoodMapping on FoodDto {
  Food mapToDomain() {
    return Food(
      id: id,
      name: name,
      category: category,
      kilojoulesPerUnit: kilojoulesPerUnit,
      quantity: quantity,
      // TODO: Map to enum
      unit: unit,
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
      kilojoulesPerUnit: kilojoules.toDouble(),
      proteinPerUnit: protein,
      quantity: 100,
      unit: "grams",
      isCustom: false,
      createdAt: now,
      updatedAt: now,
    );
    dto.tokens.addAll(tokens.map((t) => TokenDto(text: t)));
    return dto;
  }
}
