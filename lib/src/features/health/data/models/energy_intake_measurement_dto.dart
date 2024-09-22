import "package:objectbox/objectbox.dart";

@Entity()
class EnergyIntakeMeasurementDto {
  @Id()
  int id;
  double kilojoules;
  DateTime time;

  EnergyIntakeMeasurementDto({this.id = 0, required this.kilojoules, required this.time});
}
