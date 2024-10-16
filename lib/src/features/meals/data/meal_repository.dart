import 'package:snacktrack/objectbox.g.dart';
import 'package:snacktrack/src/features/meals/data/models/food_dto.dart';
import 'package:snacktrack/src/features/meals/data/models/meal_dto.dart';
import 'package:snacktrack/src/features/meals/data/models/meal_food_dto.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/features/meals/domain/meal.dart';
import 'package:snacktrack/src/features/meals/domain/meal_food.dart';

class MealRepository {
  final Store store;
  final Box<MealDto> _mealBox;
  final Box<MealFoodDto> _mealFoodBox;

  MealRepository(this.store)
      : _mealBox = store.box<MealDto>(),
        _mealFoodBox = store.box<MealFoodDto>();

  Future<List<Meal>> getMeals() async {
    var results = await _mealBox.getAllAsync();
    return results.map((r) => r.mapToDomain()).toList();
  }

  int count() => _mealBox.count();

  Future<void> createMeal(String name, List<MealFood> mealFoods) async {
    final now = DateTime.now();

    final mealDto = MealDto(
      name: name,
      createdAt: now,
      updatedAt: now,
    );

    final mealFoodDtos = mealFoods.map((mealFood) {
      final mealFoodDto = MealFoodDto(id: mealFood.id, quantity: mealFood.quantity);

      mealFoodDto.food.target = mealFood.food.mapToDto();
      mealFoodDto.meal.target = mealDto;

      return mealFoodDto;
    }).toList();

    // Objectbox will also create either side of the M2M mealFoodDto in this operation,
    // i.e. the MealDto and FoodDto
    await _mealFoodBox.putManyAsync(mealFoodDtos);
  }

  Future<void> updateMeal(int id, String name, List<MealFood> mealFoods) async {
    final storedMeal = await _mealBox.getAsync(id);
    if (storedMeal == null) {
      return;
    }

    storedMeal.name = name;
    storedMeal.updatedAt = DateTime.now();

    // Remove all existing linked foods to ensure that the meal is only linked to the current items
    storedMeal.mealsFoods.clear();
    final mealFoodDtos = mealFoods.map((mealFood) {
      final mealFoodDto = MealFoodDto(id: mealFood.id, quantity: mealFood.quantity);

      mealFoodDto.food.target = mealFood.food.mapToDto();
      mealFoodDto.meal.target = storedMeal;

      return mealFoodDto;
    }).toList();

    storedMeal.mealsFoods.addAll(mealFoodDtos);

    store.runInTransaction(TxMode.write, () {
      _mealFoodBox.putMany(mealFoodDtos); // Update any changed quantities etc
      _mealBox.put(storedMeal); // Update a changed title etc
      // TODO: Clear out orphaned mealFoods
    });
  }

  Future<void> deleteMeal(int id) async {
    final storedMeal = await _mealBox.getAsync(id);
    if (storedMeal == null) {
      return;
    }

    store.runInTransaction(TxMode.write, () {
      _mealBox.remove(storedMeal.id);
      _mealFoodBox.removeMany(storedMeal.mealsFoods.map((mealFood) => mealFood.id).toList());
    });
  }
}

extension MealMapping on MealDto {
  Meal mapToDomain() {
    return Meal(
      id: id,
      name: name,
      mealFoods: mealsFoods.map((f) => f.mapToDomain()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MealFoodDomainMapping on MealFoodDto {
  MealFood mapToDomain() {
    return MealFood(
      id: id,
      food: food.target!.mapToDomain(),
      quantity: quantity,
    );
  }
}

extension FoodDomainMapping on FoodDto {
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

extension FoodDataMapping on Food {
  FoodDto mapToDto() {
    return FoodDto(
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
