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

  EnergyUnit get energyUnit => _settingsRepository.getEnergyUnit();
  set energyUnit(EnergyUnit unit) {
    _settingsRepository.setEnergyUnit(unit).then((_) => notifyListeners());
  }

  WeightUnit get weightUnit => _settingsRepository.getWeightUnit();
  set weightUnit(WeightUnit unit) {
    _settingsRepository.setWeightUnit(unit).then((_) => notifyListeners());
  }

  int get targetEnergy => convertKilojoulesToPreferredUnits(_settingsRepository.getTargetDailyEnergyKj(), energyUnit);
  set targetEnergy(int target) {
    _settingsRepository
        .setTargetDailyEnergyKj(convertEnergyToKilojoules(target, energyUnit))
        .then((_) => notifyListeners());
  }

  double get targetWeight => convertKilogramsToPreferredUnits(_settingsRepository.getTargetWeightKg(), weightUnit);

  set targetWeight(double target) {
    _settingsRepository.setTargetWeightKg(convertWeightToKilograms(target, weightUnit)).then((_) => notifyListeners());
  }

  ThemeMode get themeMode => _settingsRepository.getThemeMode();
  set themeMode(ThemeMode theme) {
    _settingsRepository.setThemeMode(theme).then((_) => notifyListeners());
  }

  Future<void> deleteDeviceData() async {
    await _energyRepository.deleteAll();
    await _weightRepository.deleteAll();
    await _settingsRepository.deleteAll();
    notifyListeners();
  }
}
