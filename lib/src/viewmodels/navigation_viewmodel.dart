import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight_unit.dart';
import 'package:snacktrack/src/repositories/interfaces/i_energy_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';

class NavigationViewModel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  NavigationViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  void energyAddRecord(double amount) {
    _energyRepository.add(_settingsRepository.energyUnit == EnergyUnit.kj ? amount : amount / 4.184, DateTime.now());
  }

  void weightAddRecord(double amount) {
    _weightRepository.add(_settingsRepository.weightUnit == WeightUnit.kg ? amount : amount * 2.205, DateTime.now());
  }

  EnergyUnit get energyUnit => _settingsRepository.energyUnit;

  WeightUnit get weightUnit => _settingsRepository.weightUnit;

  String validator(String value) {
    if (value.isEmpty || double.tryParse(value) == null || double.parse(value) == 0.0) {
      return 'Energy invalid';
    }
    return null;
  }
}
