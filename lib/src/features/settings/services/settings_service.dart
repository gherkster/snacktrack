import "package:flutter/material.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/health/data/energy_repository.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/data/weight_repository.dart";
import "package:snacktrack/src/utilities/unit_conversion.dart";

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

  int get targetEnergy => convertKilojoulesToPreferredUnits(_settingsRepository.targetDailyEnergyKj, energyUnit);
  set targetEnergy(int target) {
    _settingsRepository.targetDailyEnergyKj = convertEnergyToKilojoules(target, energyUnit);
    notifyListeners();
  }

  double get targetWeight => convertKilogramsToPreferredUnits(_settingsRepository.targetWeightKg, weightUnit);

  set targetWeight(double target) {
    _settingsRepository.targetWeightKg = convertWeightToKilograms(target, weightUnit);
    notifyListeners();
  }

  ThemeMode get themeMode => _settingsRepository.themeMode;

  Future<void> deleteDeviceData() async {
    await _energyRepository.deleteAll();
    await _weightRepository.deleteAll();
    await _settingsRepository.deleteAll();
    notifyListeners();
  }
}
