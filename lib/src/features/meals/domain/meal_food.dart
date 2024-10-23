import "package:snacktrack/src/features/meals/domain/food.dart";

class MealFood {
  int id;
  final Food food;
  int quantity;

  MealFood({this.id = 0, required this.food, required this.quantity});

  double get totalKilojoules {
    return (food.kilojoulesPer100g / 100) * quantity;
  }
}
