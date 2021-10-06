import 'package:flutter/foundation.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:snacktrack/src/models/weight_unit.dart';

abstract class IOverviewViewModel extends ChangeNotifier {
  int get energyTarget;
  double get weightTarget;
  set weightTarget(double target);

  DateTime get today;

  int get energyCurrentTotal;
  double get weightCurrent;
  set weightCurrent(double amount);

  EnergyUnit get energyUnit;
  WeightUnit get weightUnit;

  List<Weight> get weightAllRecentValues;

  double get weightMinSelectable;
  double get weightMaxSelectable;

  double get energyCurrentTotalClamped;
}
