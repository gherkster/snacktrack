import 'package:objectbox/objectbox.dart';

@Entity()
class FoodDto {
  @Id()
  int id;
  String? externalId;
  String name;
  double kilojoulesPerUnit;
  double? proteinPerUnit;
  String unit;
  double quantity;
  bool isCustom;
  DateTime createdAt;
  DateTime updatedAt;

  FoodDto({
    this.id = 0,
    this.externalId,
    required this.name,
    required this.kilojoulesPerUnit,
    this.proteinPerUnit,
    required this.unit,
    required this.quantity,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
}
