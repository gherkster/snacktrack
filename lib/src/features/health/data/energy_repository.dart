import "package:flutter/foundation.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/features/health/domain/energy.dart";

class EnergyRepository {
  final Box _box;

  EnergyRepository(this._box);

  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  void add(double amount, DateTime time) => _box.add(Energy(amount.roundToPrecision(2), time));

  Iterable<Energy> getAll() => _box.values as Iterable<Energy>;

  void deleteAll() => _box.clear();
}
