import 'package:flutter/material.dart';
import 'package:snacktrack/src/features/meals/data/meal_repository.dart';

class MealService extends ChangeNotifier {
  final MealRepository _mealRepository;

  MealService(this._mealRepository);

  int get mealCount => _mealRepository.count();
}
