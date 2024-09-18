import 'package:dart_date/dart_date.dart';
import "package:flutter/foundation.dart";
import "package:snacktrack/src/constants.dart" as constants;
import "package:snacktrack/src/extensions/iterable.dart";
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

  @override
  DateTime get today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  int get targetEnergy => _settingsRepository.energyUnit == EnergyUnit.kilojoules
      ? _settingsRepository.energyTarget.toInt()
      : (_settingsRepository.energyTarget * constants.energyConversionFactor).toInt();

  @override
  int get currentEnergyTotal {
    final Iterable<Energy> values = _energyRepository.getAll().where((record) => record.time.isAfter(today));
    double total = values.fold(0, (sum, item) => sum + item.energy);

    total = _settingsRepository.energyUnit == EnergyUnit.kilojoules ? total : total * constants.energyConversionFactor;
    return total.toInt();
  }

  @override
  EnergyUnit get energyUnit => _settingsRepository.energyUnit;

  @override
  WeightUnit get weightUnit => _settingsRepository.weightUnit;

  @override
  List<Weight> get recentDailyWeights {
    return getLatest(7)
        .map(
          (w) => Weight(w.weight, w.time),
        )
        .toList();
  }

  @override
  double? get maximumRecentWeight => recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.weight).max : null;
  @override
  double? get minimumRecentWeight => recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.weight).min : null;

  @override
  List<Weight> getLatest(int days) {
    final List<Weight> weights = _weightRepository
        .getAllRecords()
        .where((record) => record.time.isAfter(today.subtract(Duration(days: days))))
        .toList();
    if (_settingsRepository.weightUnit == WeightUnit.pounds) {
      for (final Weight weightObj in weights) {
        weightObj.weight = weightObj.weight * constants.weightConversionFactor;
      }
    }
    return weights;
  }

  @override
  void addEnergyRecord(int amount, [DateTime? dateTime]) {
    _energyRepository.add(
      _settingsRepository.energyUnit == EnergyUnit.kilojoules
          ? amount.toDouble()
          : amount / constants.energyConversionFactor,
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  @override
  void addWeightRecord(double amount, [DateTime? dateTime]) {
    _weightRepository.add(
      _settingsRepository.weightUnit == WeightUnit.kilograms ? amount : amount / constants.weightConversionFactor,
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  @override
  int get weightMinSelectable => weightUnit == WeightUnit.kilograms ? 40 : 80;
  @override
  int get weightMaxSelectable => weightUnit == WeightUnit.kilograms ? 200 : 400;

  @override
  DateTime get minChartDate => today.addMonths(-2).addDays(-10);
  @override
  DateTime get maxChartDate => today.addDays(8);

  @override
  double get currentWeight => weightUnit == WeightUnit.kilograms
      ? _weightRepository.currentWeight
      : _weightRepository.currentWeight * constants.weightConversionFactor;
  @override
  set currentWeight(double amount) {
    _weightRepository.currentWeight =
        weightUnit == WeightUnit.kilograms ? amount : amount / constants.weightConversionFactor;
    notifyListeners();
  }

  @override
  double get targetWeight => weightUnit == WeightUnit.kilograms
      ? _settingsRepository.weightTarget
      : _settingsRepository.weightTarget * constants.weightConversionFactor;
  @override
  set targetWeight(double target) {
    _settingsRepository.weightTarget =
        weightUnit == WeightUnit.kilograms ? target : target / constants.weightConversionFactor;
    notifyListeners();
  }

  @override
  double get energyCurrentTotalClamped => (currentEnergyTotal.toDouble() / targetEnergy).clamp(0.0, 1.0).toDouble();
}
