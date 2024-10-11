import 'package:snacktrack/objectbox.g.dart';
import 'package:snacktrack/src/features/meals/data/models/food_dto.dart';
import 'package:snacktrack/src/features/meals/data/models/meal_dto.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/features/meals/domain/meal.dart';

class MealRepository {
  final Store store;
  final Box<MealDto> _box;

  MealRepository(this.store) : _box = store.box<MealDto>();

  Future<List<Meal>> getMeals() async {
    var results = await _box.getAllAsync();
    return results.map((r) => r.mapToDomain()).toList();
  }

  int count() => _box.count();

  Future<void> createMeal(String name, List<Food> foods) async {
    final now = DateTime.now();
    final mealDto = MealDto(name: name, createdAt: now, updatedAt: now);
    mealDto.foods.addAll(foods.map((f) => f.mapToDto()));

    await _box.putAsync(mealDto);
  }
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

extension FoodDomainMapping on FoodDto {
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

extension FoodDataMapping on Food {
  FoodDto mapToDto() {
    return FoodDto(
      name: name,
      category: category,
      kilojoulesPerUnit: kilojoulesPerUnit,
      unit: unit,
      quantity: quantity,
      isCustom: isCustom,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
