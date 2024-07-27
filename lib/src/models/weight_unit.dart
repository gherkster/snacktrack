import "package:hive/hive.dart";

part "weight_unit.g.dart";

@HiveType(typeId: 4)
enum WeightUnit {
  @HiveField(0)
  kg,

  @HiveField(1)
  lb,
}
