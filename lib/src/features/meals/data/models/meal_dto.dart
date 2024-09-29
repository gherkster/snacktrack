import 'package:objectbox/objectbox.dart';
import 'package:snacktrack/src/features/meals/data/models/food_dto.dart';

@Entity()
class MealDto {
  @Id()
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  final foods = ToMany<FoodDto>();

  MealDto({
    this.id = 0,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
