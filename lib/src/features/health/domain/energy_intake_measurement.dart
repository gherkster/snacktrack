import 'package:snacktrack/src/features/health/domain/energy_unit.dart';
import 'package:snacktrack/src/utilities/unit_conversion.dart';

class EnergyIntakeMeasurement {
  int id;

  final double _kilojoules;
  DateTime time;

  int get kilojoules => convertKilojoulesToPreferredUnits(_kilojoules, EnergyUnit.kilojoules);
  int get calories => convertKilojoulesToPreferredUnits(_kilojoules, EnergyUnit.calories);

  int inPreferredUnits(EnergyUnit units) {
    switch (units) {
      case EnergyUnit.kilojoules:
        return kilojoules;
      case EnergyUnit.calories:
        return calories;
    }
  }

  EnergyIntakeMeasurement({this.id = 0, required double kilojoules, required this.time}) : _kilojoules = kilojoules;
}
