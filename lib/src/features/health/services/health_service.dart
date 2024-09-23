import "package:dart_date/dart_date.dart";
import "package:flutter/foundation.dart";
import "package:snacktrack/src/extensions/datetime.dart";
import "package:snacktrack/src/extensions/iterable.dart";
import "package:snacktrack/src/features/health/data/energy_repository.dart";
import "package:snacktrack/src/features/health/domain/weight_measurement.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/data/weight_repository.dart";
import "package:snacktrack/src/utilities/unit_conversion.dart";

class HealthService extends ChangeNotifier {
  final EnergyRepository _energyRepository;
  final WeightRepository _weightRepository;
  final SettingsRepository _settingsRepository;

  HealthService(this._energyRepository, this._weightRepository, this._settingsRepository);

  int get currentEnergyTotal {
    final values = _energyRepository.getSince(DateTime.now().date);
    double total = values.fold(0, (sum, item) => sum + item.kilojoules);

    return convertKilojoulesToPreferredUnits(total, _settingsRepository.getEnergyUnit());
  }

  List<WeightMeasurement> get recentDailyWeights {
    return getLatest(7);
  }

  double? get maximumRecentWeight {
    final weightUnit = _settingsRepository.getWeightUnit();
    return recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.inPreferredUnits(weightUnit)).max : null;
  }

  double? get minimumRecentWeight {
    final weightUnit = _settingsRepository.getWeightUnit();
    return recentDailyWeights.isNotEmpty ? recentDailyWeights.map((w) => w.inPreferredUnits(weightUnit)).min : null;
  }

  List<WeightMeasurement> getLatest(int days) => _weightRepository.getSince(DateTime.now().date.subDays(days));

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
    final weight = _weightRepository.getLatest();
    if (weight == null) {
      return null;
    }

    return weight.inPreferredUnits(_settingsRepository.getWeightUnit());
  }

  double get energyCurrentTotalClamped =>
      (currentEnergyTotal / (_settingsRepository.getTargetDailyEnergyKj())).clamp(0.0, 1.0).toDouble();
}
