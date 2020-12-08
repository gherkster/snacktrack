import 'package:flutter/material.dart';
import 'package:snacktrack/src/models/day.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight_unit.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';

class SettingsViewModel {
  final ISettingsRepository _settingsRepository;

  SettingsViewModel(this._settingsRepository);

  EnergyUnit get energyUnit => _settingsRepository.energyUnit;
  set energyUnit(EnergyUnit unit) => _settingsRepository.energyUnit = unit;

  WeightUnit get weightUnit => _settingsRepository.weightUnit;
  set weightUnit(WeightUnit unit) => _settingsRepository.weightUnit = unit;

  ThemeMode get themeMode => _settingsRepository.themeMode;

  Day get weekStart => _settingsRepository.weekStart;
  set weekStart(Day day) => _settingsRepository.weekStart = day;
}
