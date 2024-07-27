import "package:hive/hive.dart";

part "energy_unit.g.dart";

@HiveType(typeId: 3)
enum EnergyUnit {
  @HiveField(0)
  kj,

  @HiveField(1)
  cal,
}
