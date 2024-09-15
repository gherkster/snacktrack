import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/models/day.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";

import "interfaces/i_settings_repository.dart";

class SettingsRepository implements ISettingsRepository {
  final Box _box;

  SettingsRepository(this._box);

  @override
  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  @override
  EnergyUnit get energyUnit => _box.get("energyUnit") as EnergyUnit? ?? EnergyUnit.kilojoules;
  @override
  set energyUnit(EnergyUnit unit) => _box.put("energyUnit", unit);

  @override
  double get energyTarget => _box.get("energyTarget") as double? ?? 8500.0;
  @override
  set energyTarget(double target) => _box.put("energyTarget", target.roundToPrecision(2));

  @override
  WeightUnit get weightUnit => _box.get("weightUnit") as WeightUnit? ?? WeightUnit.kilograms;
  @override
  set weightUnit(WeightUnit unit) => _box.put("weightUnit", unit);

  @override
  double get weightTarget => _box.get("weightTarget") as double? ?? 70.0;
  @override
  set weightTarget(double target) => _box.put("weightTarget", target.roundToPrecision(2));

  @override
  ThemeMode get themeMode => _box.get("themeMode") as ThemeMode? ?? ThemeMode.system;
  @override
  set themeMode(ThemeMode mode) => _box.put("themeMode", mode);

  @override
  Day get weekStart => _box.get("weekStart") as Day? ?? Day.monday;
  @override
  set weekStart(Day day) => _box.put("weekStart", day);

  @override
  void deleteAll() => _box.clear();
}
