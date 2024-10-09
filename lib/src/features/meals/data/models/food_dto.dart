import 'package:objectbox/objectbox.dart';
import 'package:snacktrack/src/features/meals/data/models/token_dto.dart';

@Entity()
class FoodDto {
  @Id()
  int id;
  String name;
  String category;
  double kilojoulesPerUnit;
  double? proteinPerUnit;
  String unit;
  int quantity;
  bool isCustom;
  final tokens = ToMany<TokenDto>();
  DateTime createdAt;
  DateTime updatedAt;

  FoodDto({
    this.id = 0,
    required this.name,
    required this.category,
    required this.kilojoulesPerUnit,
    this.proteinPerUnit,
    required this.unit,
    required this.quantity,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
}
