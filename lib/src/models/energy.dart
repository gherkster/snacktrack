import 'package:hive/hive.dart';

part 'energy.g.dart';

@HiveType(typeId: 1)
class Energy extends HiveObject {
  @HiveField(0)
  double energy; // Stored in kilojoules

  @HiveField(1)
  DateTime time;

  Energy(this.energy, this.time);
}
