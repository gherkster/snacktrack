import "package:flutter/widgets.dart";
import "package:snacktrack/src/constants.dart" as constants;
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/repositories/interfaces/i_energy_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_settings_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_weight_repository.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_navigation_viewmodel.dart";

class NavigationViewModel extends ChangeNotifier implements INavigationViewModel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  NavigationViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  @override
  void energyAddRecord(double amount) {
    _energyRepository.add(_settingsRepository.energyUnit == EnergyUnit.kj ? amount : amount / constants.energyConversionFactor, DateTime.now());
    notifyListeners();
  }

  @override
  void weightAddRecord(double amount) {
    _weightRepository.add(_settingsRepository.weightUnit == WeightUnit.kg ? amount : amount / constants.weightConversionFactor, DateTime.now());
    notifyListeners();
  }

  @override
  EnergyUnit get energyUnit => _settingsRepository.energyUnit;
  @override
  WeightUnit get weightUnit => _settingsRepository.weightUnit;

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) == 0.0) {
      return "Energy invalid";
    }
    return null;
  }
}
