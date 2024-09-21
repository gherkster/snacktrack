import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/utilities/constants.dart";

class SettingsRepository {
  final SharedPreferencesWithCache _prefs;

  SettingsRepository(this._prefs);

  EnergyUnit getEnergyUnit() {
    final value = _prefs.getInt("energyUnit");
    return value != null ? EnergyUnit.fromValue(value) ?? defaultEnergyUnit : defaultEnergyUnit;
  }

  Future<void> setEnergyUnit(EnergyUnit unit) => _prefs.setInt("energyUnit", unit.value);

  double getTargetDailyEnergyKj() => _prefs.getDouble("energyTarget") ?? defaultEnergyTargetKj;
  Future<void> setTargetDailyEnergyKj(double target) => _prefs.setDouble("energyTarget", target);

  WeightUnit getWeightUnit() {
    final value = _prefs.getInt("weightUnit");
    return value != null ? WeightUnit.fromValue(value) ?? defaultWeightUnit : defaultWeightUnit;
  }

  Future<void> setWeightUnit(WeightUnit unit) => _prefs.setInt("weightUnit", unit.value);

  double getTargetWeightKg() => _prefs.getDouble("weightTarget") ?? defaultWeightTargetKg;

  Future<void> setTargetWeightKg(double target) => _prefs.setDouble("weightTarget", target);

  ThemeMode getThemeMode() {
    final value = _prefs.getInt("themeMode");
    return value != null ? ThemeMode.values.where((v) => v.index == value).firstOrNull ?? defaultTheme : defaultTheme;
  }

  Future<void> setThemeMode(ThemeMode mode) => _prefs.setInt("themeMode", mode.index);

  Future<void> deleteAll() async => await _prefs.clear();
}
