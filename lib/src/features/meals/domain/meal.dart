import "package:snacktrack/src/features/meals/domain/meal_food.dart";

class Meal {
  final int id;
  final String name;
  final List<MealFood> mealFoods;

  final DateTime createdAt;
  final DateTime updatedAt;

  Meal({
    this.id = 0,
    required this.name,
    required this.mealFoods,
    required this.createdAt,
    required this.updatedAt,
  });
}
