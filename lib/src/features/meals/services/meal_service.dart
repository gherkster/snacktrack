import 'package:flutter/material.dart';
import 'package:snacktrack/src/features/meals/data/food_repository.dart';
import 'package:snacktrack/src/features/meals/data/meal_repository.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/features/meals/domain/meal.dart';

class MealService extends ChangeNotifier {
  final MealRepository _mealRepository;
  final FoodRepository _foodRepository;

  MealService(this._mealRepository, this._foodRepository);

  int get mealCount => _mealRepository.count();

  Future<List<Meal>> getMeals() async {
    return await _mealRepository.getMeals();
  }

  Future<void> createMeal(String name, List<Food> foods) async {
    await _mealRepository.createMeal(name, foods);
    notifyListeners();
  }

  Future<void> updateMeal(int id, String name, List<Food> foods) async {
    await _mealRepository.updateMeal(id, name, foods);
    notifyListeners();
  }

  Future<void> deleteMeal(int id) async {
    await _mealRepository.deleteMeal(id);
    notifyListeners();
  }

  Future<List<Food>> searchFoods(String queryText, [int limit = 10]) async {
    return await _foodRepository.searchFoods(queryText, limit);
  }
}
