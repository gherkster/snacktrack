import 'package:snacktrack/src/features/meals/domain/food.dart';

class Meal {
  final int id;
  final String name;
  final String description;
  final List<Food> foods;

  final DateTime createdAt;
  final DateTime updatedAt;

  Meal({
    this.id = 0,
    required this.name,
    required this.description,
    required this.foods,
    required this.createdAt,
    required this.updatedAt,
  });
}
