import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'interfaces/i_weight_repository.dart';

class WeightRepository implements IWeightRepository {
  final Box _box;

  WeightRepository(this._box);

  @override
  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  @override
  void add(double amount, DateTime time) => _box.add(Weight(amount, time));

  @override
  void put(double amount, DateTime time) => _box.put(time.millisecondsSinceEpoch.toString(), Weight(amount, time));

  @override
  Iterable<Weight> getAllRecords() => _box.values as Iterable<Weight>;

  @override
  double getLatest() {
    final int index = _box.toMap().length - 1;
    if (index < 0) {
      return 70.0;
    } else {
      final Weight latest = _box.values.toList()[index] as Weight;
      return latest.weight;
    }
  }

  @override
  void deleteAll() => _box.clear();
}
