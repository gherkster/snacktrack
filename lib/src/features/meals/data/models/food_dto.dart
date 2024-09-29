import 'package:objectbox/objectbox.dart';

@Entity()
class FoodDto {
  @Id()
  int id;
  String name;
  double kilojoulesPerUnit;
  String unit;
  double quantity;
  bool isCustom;
  DateTime createdAt;
  DateTime updatedAt;

  FoodDto({
    this.id = 0,
    required this.name,
    required this.kilojoulesPerUnit,
    required this.unit,
    required this.quantity,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
}
