import "package:flutter/foundation.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/models/weight.dart";

class WeightRepository {
  final Box _box;

  WeightRepository(this._box);

  DateTime get _today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  void add(double amount, DateTime time) => _box.add(Weight(amount.roundToPrecision(2), time));

  void put(double amount, DateTime time) =>
      _box.put(time.millisecondsSinceEpoch.toString(), Weight(amount.roundToPrecision(2), time));

  double get currentWeight => _getLatest();
  set currentWeight(double amount) => put(amount, _today);

  Iterable<Weight> getAllRecords() => _box.values as Iterable<Weight>;

  double _getLatest() {
    final int lastIndex = _box.toMap().length - 1;
    if (lastIndex < 0) {
      return 70.0;
    } else {
      final Weight latest = _box.values.toList()[lastIndex] as Weight;
      return latest.weight;
    }
  }

  void deleteAll() => _box.clear();
}
