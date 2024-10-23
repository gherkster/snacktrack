import "package:objectbox/objectbox.dart";
import "package:snacktrack/src/features/meals/data/models/meal_food_dto.dart";
import "package:snacktrack/src/features/meals/data/models/token_dto.dart";

@Entity()
class FoodDto {
  @Id()
  int id;
  String name;
  String category;
  double kilojoulesPer100g;
  double? proteinPerUnit;
  bool isCustom;
  DateTime createdAt;
  DateTime updatedAt;

  /// Link to join table
  @Backlink("food")
  final mealsFoods = ToMany<MealFoodDto>();

  final tokens = ToMany<TokenDto>();

  FoodDto({
    this.id = 0,
    required this.name,
    required this.category,
    required this.kilojoulesPer100g,
    this.proteinPerUnit,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
}
