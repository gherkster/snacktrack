import "package:flutter/foundation.dart";
import "package:snacktrack/src/extensions/datetime.dart";
import "package:snacktrack/src/extensions/iterable.dart";
import "package:snacktrack/src/features/health/domain/energy.dart";
import "package:snacktrack/src/features/health/domain/weight.dart";
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

    return convertKilojoulesToPreferredUnits(total, _settingsRepository.getEnergyUnit());
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
    final weightUnit = _settingsRepository.getWeightUnit();
    for (final Weight record in weights) {
      record.weight = convertKilogramsToPreferredUnits(record.weight, weightUnit);
    }
    return weights;
  }

  void addEnergyRecord(int amount, [DateTime? dateTime]) {
    _energyRepository.addKj(
      convertEnergyToKilojoules(amount, _settingsRepository.getEnergyUnit()),
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  void addWeightRecord(double amount, [DateTime? dateTime]) {
    _weightRepository.addKg(
      convertWeightToKilograms(amount, _settingsRepository.getWeightUnit()),
      dateTime ?? DateTime.now(),
    );
    notifyListeners();
  }

  double? get currentWeight {
    final weight = _weightRepository.currentWeightKg;
    if (weight == null) {
      return null;
    }

    return convertWeightToKilograms(weight, _settingsRepository.getWeightUnit());
  }

  double get energyCurrentTotalClamped =>
      (currentEnergyTotal / (_settingsRepository.getTargetDailyEnergyKj())).clamp(0.0, 1.0).toDouble();
}
