import 'package:objectbox/objectbox.dart';

@Entity()
class WeightMeasurementDto {
  @Id()
  int id;
  double kilograms;
  DateTime time;

  WeightMeasurementDto({this.id = 0, required this.kilograms, required this.time});
}
