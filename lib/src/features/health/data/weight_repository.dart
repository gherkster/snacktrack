import "package:flutter/foundation.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/features/health/domain/weight.dart";

class WeightRepository {
  final Box _box;

  WeightRepository(this._box);

  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  void addKg(double amount, DateTime time) => _box.add(Weight(amount.roundToPrecision(2), time));

  double? get currentWeightKg => _getLatest();

  Iterable<Weight> getAllKgRecords() => _box.values as Iterable<Weight>;

  double? _getLatest() {
    final int lastIndex = _box.toMap().length - 1;
    if (lastIndex < 0) {
      return null;
    } else {
      final Weight latest = _box.values.toList()[lastIndex] as Weight;
      return latest.weight;
    }
  }

  void deleteAll() => _box.clear();
}
