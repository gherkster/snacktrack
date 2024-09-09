import "package:flutter/foundation.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/models/weight_unit.dart";

abstract class IOverviewViewModel extends ChangeNotifier {
  int get targetEnergy;

  double get currentWeight;
  set currentWeight(double amount);

  double get targetWeight;
  set targetWeight(double target);

  int get currentEnergyTotal;

  WeightUnit get weightUnit;

  List<Weight> get weightAllRecentValues;
  // Potentially just get the values, then use another function to generate the empty values for any Date
  List<Weight> getPreviousWeightsFilled(int days);

  double get weightMinSelectable;
  double get weightMaxSelectable;

  double get energyCurrentTotalClamped;
}
