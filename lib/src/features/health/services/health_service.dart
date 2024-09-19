import 'package:dart_date/dart_date.dart';
import "package:flutter/foundation.dart";
import "package:snacktrack/src/extensions/datetime.dart";
import "package:snacktrack/src/extensions/iterable.dart";
import "package:snacktrack/src/features/health/domain/energy.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/health/data/energy_repository.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/data/weight_repository.dart";
import "package:snacktrack/src/utilities/unit_conversion.dart";

class HealthService extends ChangeNotifier {
  final EnergyRepository _energyRepository;
  final WeightRepository _weightRepository;
  final SettingsRepository _settingsRepository;

  HealthService(this._energyRepository, this._weightRepository, this._settingsRepository);

  int get currentEnergyTotal {
    final Iterable<Energy> values =
        _energyRepository.getAll().where((record) => record.time.isAfter(DateTime.now().date));
    double total = values.fold(0, (sum, item) => sum + item.energy);

    return convertKilojoulesToPreferredUnits(total, _settingsRepository.energyUnit);
  }

  List<Weight> get recentDailyWeights {
    return getLatest(7);
  }

  double? get maximumRecentWeight => recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.weight).max : null;
  double? get minimumRecentWeight => recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.weight).min : null;

  List<Weight> getLatest(int days) {
    final List<Weight> weights = _weightRepository
        .getAllKgRecords()
        .where((record) => record.time.isAfter(DateTime.now().date.subtract(Duration(days: days))))
        .toList();
    final weightUnit = _settingsRepository.weightUnit;
    for (final Weight record in weights) {
      record.weight = convertKilogramsToPreferredUnits(record.weight, weightUnit);
    }
    return weights;
  }

  void addEnergyRecord(int amount, [DateTime? dateTime]) {
    _energyRepository.addKj(
      convertEnergyToKilojoules(amount, _settingsRepository.energyUnit),
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  void addWeightRecord(double amount, [DateTime? dateTime]) {
    _weightRepository.addKg(
      convertWeightToKilograms(amount, _settingsRepository.weightUnit),
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  int get weightMinSelectable => _settingsRepository.weightUnit == WeightUnit.kilograms ? 40 : 80;
  int get weightMaxSelectable => _settingsRepository.weightUnit == WeightUnit.kilograms ? 200 : 400;

  DateTime get minChartDate => DateTime.now().date.addMonths(-2).addDays(-10);
  DateTime get maxChartDate => DateTime.now().date.addDays(8);

  double? get currentWeight {
    final weight = _weightRepository.currentWeightKg;
    if (weight == null) {
      return null;
    }

    return convertWeightToKilograms(weight, _settingsRepository.weightUnit);
  }

  double get energyCurrentTotalClamped =>
      (currentEnergyTotal / _settingsRepository.targetDailyEnergyKj).clamp(0.0, 1.0).toDouble();
}
