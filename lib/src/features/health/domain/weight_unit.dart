import "package:hive/hive.dart";

part "weight_unit.g.dart";

@HiveType(typeId: 4)
enum WeightUnit {
  @HiveField(0)
  kilograms("kg", "Kilograms"),

  @HiveField(1)
  pounds("lb", "Pounds");

  const WeightUnit(this.shortName, this.longName);
  final String shortName;
  final String longName;
}
