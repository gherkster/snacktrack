import 'package:flutter/material.dart';
import 'package:snacktrack/src/features/meals/data/food_repository.dart';
import 'package:snacktrack/src/features/meals/data/meal_repository.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';

class MealService extends ChangeNotifier {
  final MealRepository _mealRepository;
  final FoodRepository _foodRepository;

  MealService(this._mealRepository, this._foodRepository);

  int get mealCount => _mealRepository.count();

  Future<List<Food>> searchFoods(String queryText, [int limit = 10]) async {
    return await _foodRepository.searchFoods(queryText, limit);
  }
}
