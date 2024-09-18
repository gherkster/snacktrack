import "package:hive/hive.dart";

part "energy_unit.g.dart";

@HiveType(typeId: 3)
enum EnergyUnit {
  @HiveField(0)
  kilojoules("kJ", "Kilojoules"),

  @HiveField(1)
  calories("Cal", "Calories");

  const EnergyUnit(this.shortName, this.longName);
  final String shortName;
  final String longName;
}
