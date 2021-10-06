import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snacktrack/src/models/day.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight_unit.dart';

abstract class ISettingsViewmodel extends ChangeNotifier {
  EnergyUnit get energyUnit;
  set energyUnit(EnergyUnit unit);

  WeightUnit get weightUnit;
  set weightUnit(WeightUnit unit);

  double get energyTarget;
  set energyTarget(double target);

  double get weightTarget;
  set weightTarget(double target);

  ThemeMode get themeMode;

  Day get weekStart;
  set weekStart(Day day);

  void deleteDeviceData();
}
