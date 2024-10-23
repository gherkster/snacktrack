import "package:objectbox/objectbox.dart";
import "package:snacktrack/src/features/meals/data/models/food_dto.dart";
import "package:snacktrack/src/features/meals/data/models/meal_dto.dart";

/// Implements a "join table" for objectbox to allow specifying quantities
/// when linking a meal to foods
@Entity()
class MealFoodDto {
  @Id()
  int id;

  final meal = ToOne<MealDto>();
  final food = ToOne<FoodDto>();

  // Quantity of the food in this meal configuration
  int quantity;

  MealFoodDto({this.id = 0, this.quantity = 0});
}
