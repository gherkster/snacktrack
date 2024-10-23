import "package:objectbox/objectbox.dart";
import "package:snacktrack/src/features/meals/data/models/meal_food_dto.dart";

@Entity()
class MealDto {
  @Id()
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  /// Link to join table
  @Backlink("meal")
  final mealsFoods = ToMany<MealFoodDto>();

  MealDto({
    this.id = 0,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
