import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:snacktrack/src/models/day.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight_unit.dart';

abstract class ISettingsRepository {
  ValueListenable<Box<dynamic>> get stream;

  EnergyUnit get energyUnit;
  set energyUnit(EnergyUnit unit);

  double get energyTarget;
  set energyTarget(double target);

  WeightUnit get weightUnit;
  set weightUnit(WeightUnit unit);

  double get weightTarget;
  set weightTarget(double target);

  ThemeMode get themeMode;
  set themeMode(ThemeMode mode);

  Day get weekStart;
  set weekStart(Day day);
}
