import 'package:snacktrack/src/features/meals/domain/food.dart';

class Meal {
  final int id;
  final String name;
  final List<Food> foods;

  final DateTime createdAt;
  final DateTime updatedAt;

  Meal({
    this.id = 0,
    required this.name,
    required this.foods,
    required this.createdAt,
    required this.updatedAt,
  });
}
