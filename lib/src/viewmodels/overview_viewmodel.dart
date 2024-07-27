import "package:flutter/foundation.dart";
import "package:snacktrack/src/constants.dart" as constants;
import "package:snacktrack/src/models/energy.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/repositories/interfaces/i_energy_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_settings_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_weight_repository.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart";

class OverviewViewModel extends ChangeNotifier implements IOverviewViewModel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  OverviewViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  DateTime get _today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  int get targetEnergy => _settingsRepository.energyUnit == EnergyUnit.kj
      ? _settingsRepository.energyTarget.toInt()
      : (_settingsRepository.energyTarget * constants.energyConversionFactor).toInt();

  @override
  int get currentEnergyTotal {
    final Iterable<Energy> values = _energyRepository.getAll().where((record) => record.time.isAfter(_today));
    double total = values.fold(0, (sum, item) => sum + item.energy);

    total = _settingsRepository.energyUnit == EnergyUnit.kj ? total : total * constants.energyConversionFactor;
    return total.toInt();
  }

  @override
  WeightUnit get weightUnit => _settingsRepository.weightUnit;

  @override
  List<Weight> get weightAllRecentValues {
    final List<Weight> weights = _weightRepository.getAllRecords().where((record) => record.time.isAfter(_today.subtract(const Duration(days: 14)))).toList();
    if (_settingsRepository.weightUnit == WeightUnit.lb) {
      for (final Weight weightObj in weights) {
        weightObj.weight = weightObj.weight * constants.weightConversionFactor;
      }
    }
    return weights;
  }

  @override
  double get weightMinSelectable => weightUnit == WeightUnit.kg ? 40.0 : 80.0;
  @override
  double get weightMaxSelectable => weightUnit == WeightUnit.kg ? 200.0 : 400.0;

  @override
  double get currentWeight =>
      weightUnit == WeightUnit.kg ? _weightRepository.currentWeight : _weightRepository.currentWeight * constants.weightConversionFactor;
  @override
  set currentWeight(double amount) {
    _weightRepository.currentWeight = weightUnit == WeightUnit.kg ? amount : amount / constants.weightConversionFactor;
    notifyListeners();
  }

  @override
  double get targetWeight =>
      weightUnit == WeightUnit.kg ? _settingsRepository.weightTarget : _settingsRepository.weightTarget * constants.weightConversionFactor;
  @override
  set targetWeight(double target) {
    _settingsRepository.weightTarget = weightUnit == WeightUnit.kg ? target : target / constants.weightConversionFactor;
    notifyListeners();
  }

  @override
  double get energyCurrentTotalClamped => (currentEnergyTotal.toDouble() / targetEnergy).clamp(0.0, 1.0).toDouble();
}
