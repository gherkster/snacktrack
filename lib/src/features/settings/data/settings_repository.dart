import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";

class SettingsRepository {
  final Box _box;

  SettingsRepository(this._box);

  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  EnergyUnit get energyUnit => _box.get("energyUnit") as EnergyUnit? ?? EnergyUnit.kilojoules;
  set energyUnit(EnergyUnit unit) => _box.put("energyUnit", unit);

  double get targetDailyEnergyKj => _box.get("energyTarget") as double? ?? 8500.0;
  set targetDailyEnergyKj(double target) => _box.put("energyTarget", target.roundToPrecision(2));

  WeightUnit get weightUnit => _box.get("weightUnit") as WeightUnit? ?? WeightUnit.kilograms;
  set weightUnit(WeightUnit unit) => _box.put("weightUnit", unit);

  double get targetWeightKg => _box.get("weightTarget") as double? ?? 70.0;
  set targetWeightKg(double target) => _box.put("weightTarget", target.roundToPrecision(2));

  ThemeMode get themeMode => _box.get("themeMode") as ThemeMode? ?? ThemeMode.system;
  set themeMode(ThemeMode mode) => _box.put("themeMode", mode);

  Future<void> deleteAll() async => await _box.clear();
}
