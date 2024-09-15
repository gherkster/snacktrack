import "package:flutter/foundation.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";

abstract class INavigationViewModel extends ChangeNotifier {
  EnergyUnit get energyUnit;

  WeightUnit get weightUnit;

  String? validator(String? value);
}
