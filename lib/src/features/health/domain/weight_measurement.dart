import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/utilities/unit_conversion.dart";

class WeightMeasurement {
  final int id;
  final double _kilograms;
  final DateTime time;

  double get kilograms => convertKilogramsToPreferredUnits(_kilograms, WeightUnit.kilograms);
  double get pounds => convertKilogramsToPreferredUnits(_kilograms, WeightUnit.pounds);

  double inPreferredUnits(WeightUnit units) {
    switch (units) {
      case WeightUnit.kilograms:
        return kilograms;
      case WeightUnit.pounds:
        return pounds;
    }
  }

  WeightMeasurement({this.id = 0, required double kilograms, required this.time}) : _kilograms = kilograms;
}
