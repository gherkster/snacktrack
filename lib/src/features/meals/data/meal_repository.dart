import 'package:snacktrack/objectbox.g.dart';
import 'package:snacktrack/src/features/meals/data/models/food_dto.dart';
import 'package:snacktrack/src/features/meals/data/models/meal_dto.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/features/meals/domain/meal.dart';

class MealRepository {
  final Box<MealDto> _box;

  MealRepository(this._box);

  List<Meal> getMeals() {
    var results = _box.getAll();
    return results.map((r) => r.mapToDomain()).toList();
  }

  int count() => _box.count();
}

extension MealMapping on MealDto {
  Meal mapToDomain() {
    return Meal(
        id: id,
        name: name,
        foods: foods.map((f) => f.mapToDomain()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt);
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
