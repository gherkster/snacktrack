import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:snacktrack/src/models/energy.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:snacktrack/src/models/weight_unit.dart';
import 'package:snacktrack/src/repositories/interfaces/i_energy_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';

class OverviewViewModel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  OverviewViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  ValueListenable<Box<dynamic>> get energyStream => _energyRepository.stream;
  ValueListenable<Box<dynamic>> get weightStream => _weightRepository.stream;
  ValueListenable<Box<dynamic>> get settingsStream => _settingsRepository.stream;

  int get energyTarget =>
      _settingsRepository.energyUnit == EnergyUnit.kj ? _settingsRepository.energyTarget.toInt() : _settingsRepository.energyTarget ~/ 4.184;

  DateTime get today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int get energyCurrentTotal {
    final Iterable<Energy> values = _energyRepository.getAll().where((record) => record.time.isAfter(today));
    double total = values.fold(0, (sum, item) => sum + item.energy);

    total = _settingsRepository.energyUnit == EnergyUnit.kj ? total : total / 4.184;
    return total.toInt();
  }

  EnergyUnit get energyUnit => _settingsRepository.energyUnit;
  WeightUnit get weightUnit => _settingsRepository.weightUnit;

  List<Weight> get weightAllRecentValues {
    final List<Weight> weights = _weightRepository.getAllRecords().where((record) => record.time.isAfter(today.subtract(const Duration(days: 14)))).toList();
    if (_settingsRepository.weightUnit == WeightUnit.lb) {
      for (final Weight weight in weights) {
        weight.weight = weight.weight * 2;
      }
    }
    return weights;
  }

  double get weightCurrent {
    final double current = _weightRepository.getLatest();
    return _settingsRepository.weightUnit == WeightUnit.kg ? double.parse(current.toStringAsFixed(2)) : double.parse((current * 2.205).toStringAsFixed(2));
  }

  set weightCurrent(double amount) {
    _weightRepository.put(amount, today);
  }

  double get weightTarget {
    return _settingsRepository.weightTarget;
  }

  set weightTarget(double target) {
    _settingsRepository.weightTarget = target;
  }

  double get energyCurrentTotalClamped => (energyCurrentTotal.toDouble() / energyTarget).clamp(0.0, 1.0).toDouble();
}
