import "package:hive/hive.dart";

part "day.g.dart";

@HiveType(typeId: 6)
enum Day {
  @HiveField(0)
  monday,

  @HiveField(1)
  tuesday,

  @HiveField(2)
  wednesday,

  @HiveField(3)
  thursday,

  @HiveField(4)
  friday,

  @HiveField(5)
  saturday,

  @HiveField(6)
  sunday,
}
