import "package:flutter/foundation.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/extensions.dart";
import "package:snacktrack/src/models/energy.dart";
import "package:snacktrack/src/repositories/interfaces/i_energy_repository.dart";

class EnergyRepository implements IEnergyRepository {
  final Box _box;

  EnergyRepository(this._box);

  @override
  ValueListenable<Box<dynamic>> get stream => _box.listenable();

  @override
  void add(double amount, DateTime time) => _box.add(Energy(amount.roundToPrecision(2), time));

  @override
  Iterable<Energy> getAll() => _box.values as Iterable<Energy>;

  @override
  void deleteAll() => _box.clear();
}
