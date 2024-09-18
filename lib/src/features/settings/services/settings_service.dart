import "package:flutter/material.dart";
import "package:snacktrack/src/constants.dart" as constants;
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/health/data/energy_repository.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/data/weight_repository.dart";

class SettingsService extends ChangeNotifier {
  final EnergyRepository _energyRepository;
  final WeightRepository _weightRepository;
  final SettingsRepository _settingsRepository;

  SettingsService(this._energyRepository, this._weightRepository, this._settingsRepository);

  EnergyUnit get energyUnit => _settingsRepository.energyUnit;
  set energyUnit(EnergyUnit unit) {
    _settingsRepository.energyUnit = unit;
    notifyListeners();
  }

  WeightUnit get weightUnit => _settingsRepository.weightUnit;
  set weightUnit(WeightUnit unit) {
    _settingsRepository.weightUnit = unit;
    notifyListeners();
  }

  int get targetEnergy => _settingsRepository.energyUnit == EnergyUnit.kilojoules
      ? _settingsRepository.energyTarget.toInt()
      : (_settingsRepository.energyTarget * constants.energyConversionFactor).toInt();

  double get targetWeight => weightUnit == WeightUnit.kilograms
      ? _settingsRepository.weightTarget
      : _settingsRepository.weightTarget * constants.weightConversionFactor;

  set targetWeight(double target) {
    _settingsRepository.weightTarget =
        weightUnit == WeightUnit.kilograms ? target : target / constants.weightConversionFactor;
    notifyListeners();
  }

  ThemeMode get themeMode => _settingsRepository.themeMode;

  void deleteDeviceData() {
    _energyRepository.deleteAll();
    _weightRepository.deleteAll();
    _settingsRepository.deleteAll();
    notifyListeners();
  }
}