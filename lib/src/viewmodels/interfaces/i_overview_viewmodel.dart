import 'package:flutter/foundation.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:snacktrack/src/models/weight_unit.dart';

abstract class IOverviewViewModel extends ChangeNotifier {
  int get targetEnergy;

  double get currentWeight;
  set currentWeight(double amount);

  double get targetWeight;
  set targetWeight(double target);

  int get currentEnergyTotal;

  WeightUnit get weightUnit;

  List<Weight> get weightAllRecentValues;

  double get weightMinSelectable;
  double get weightMaxSelectable;

  double get energyCurrentTotalClamped;
}
