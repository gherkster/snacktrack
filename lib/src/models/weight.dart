import 'package:hive/hive.dart';

part 'weight.g.dart';

@HiveType(typeId: 2)
class Weight extends HiveObject {
  @HiveField(0)
  double weight; // Stored in kilograms

  @HiveField(2)
  DateTime time;

  Weight(this.weight, this.time);
}
