import "package:flutter/material.dart";
import "package:snacktrack/src/models/day.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/repositories/interfaces/i_energy_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_settings_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_weight_repository.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";

class SettingsViewModel extends ChangeNotifier implements ISettingsViewmodel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  SettingsViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  @override
  EnergyUnit get energyUnit => _settingsRepository.energyUnit;
  @override
  set energyUnit(EnergyUnit unit) {
    _settingsRepository.energyUnit = unit;
    notifyListeners();
  }

  @override
  WeightUnit get weightUnit => _settingsRepository.weightUnit;
  @override
  set weightUnit(WeightUnit unit) {
    _settingsRepository.weightUnit = unit;
    notifyListeners();
  }

  @override
  double get energyTarget => _settingsRepository.energyTarget;
  @override
  set energyTarget(double target) {
    _settingsRepository.energyTarget = target;
    notifyListeners();
  }

  @override
  double get weightTarget => _settingsRepository.weightTarget;
  @override
  set weightTarget(double target) {
    _settingsRepository.weightTarget = target;
    notifyListeners();
  }

  @override
  ThemeMode get themeMode => _settingsRepository.themeMode;

  @override
  Day get weekStart => _settingsRepository.weekStart;
  @override
  set weekStart(Day day) {
    _settingsRepository.weekStart = day;
    notifyListeners();
  }

  @override
  void deleteDeviceData() {
    _energyRepository.deleteAll();
    _weightRepository.deleteAll();
    _settingsRepository.deleteAll();
    notifyListeners();
  }
}
