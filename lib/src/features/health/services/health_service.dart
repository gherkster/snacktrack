import 'package:dart_date/dart_date.dart';
import "package:flutter/foundation.dart";
import "package:snacktrack/src/constants.dart" as constants;
import "package:snacktrack/src/extensions/iterable.dart";
import "package:snacktrack/src/features/health/domain/energy.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/health/data/energy_repository.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/data/weight_repository.dart";

class OverviewViewModel extends ChangeNotifier {
  final EnergyRepository _energyRepository;
  final WeightRepository _weightRepository;
  final SettingsRepository _settingsRepository;

  OverviewViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  DateTime get today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int get targetEnergy => _settingsRepository.energyUnit == EnergyUnit.kilojoules
      ? _settingsRepository.energyTarget.toInt()
      : (_settingsRepository.energyTarget * constants.energyConversionFactor).toInt();

  int get currentEnergyTotal {
    final Iterable<Energy> values = _energyRepository.getAll().where((record) => record.time.isAfter(today));
    double total = values.fold(0, (sum, item) => sum + item.energy);

    total = _settingsRepository.energyUnit == EnergyUnit.kilojoules ? total : total * constants.energyConversionFactor;
    return total.toInt();
  }

  EnergyUnit get energyUnit => _settingsRepository.energyUnit;

  WeightUnit get weightUnit => _settingsRepository.weightUnit;

  List<Weight> get recentDailyWeights {
    return getLatest(7)
        .map(
          (w) => Weight(w.weight, w.time),
        )
        .toList();
  }

  double? get maximumRecentWeight => recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.weight).max : null;
  double? get minimumRecentWeight => recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.weight).min : null;

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

  void addEnergyRecord(int amount, [DateTime? dateTime]) {
    _energyRepository.add(
      _settingsRepository.energyUnit == EnergyUnit.kilojoules
          ? amount.toDouble()
          : amount / constants.energyConversionFactor,
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  void addWeightRecord(double amount, [DateTime? dateTime]) {
    _weightRepository.add(
      _settingsRepository.weightUnit == WeightUnit.kilograms ? amount : amount / constants.weightConversionFactor,
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  int get weightMinSelectable => weightUnit == WeightUnit.kilograms ? 40 : 80;
  int get weightMaxSelectable => weightUnit == WeightUnit.kilograms ? 200 : 400;

  DateTime get minChartDate => today.addMonths(-2).addDays(-10);
  DateTime get maxChartDate => today.addDays(8);

  double get currentWeight => weightUnit == WeightUnit.kilograms
      ? _weightRepository.currentWeight
      : _weightRepository.currentWeight * constants.weightConversionFactor;

  set currentWeight(double amount) {
    _weightRepository.currentWeight =
        weightUnit == WeightUnit.kilograms ? amount : amount / constants.weightConversionFactor;
    notifyListeners();
  }

  double get targetWeight => weightUnit == WeightUnit.kilograms
      ? _settingsRepository.weightTarget
      : _settingsRepository.weightTarget * constants.weightConversionFactor;

  set targetWeight(double target) {
    _settingsRepository.weightTarget =
        weightUnit == WeightUnit.kilograms ? target : target / constants.weightConversionFactor;
    notifyListeners();
  }

  double get energyCurrentTotalClamped => (currentEnergyTotal.toDouble() / targetEnergy).clamp(0.0, 1.0).toDouble();
}
