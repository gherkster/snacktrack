import "package:flutter/foundation.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/models/weight_unit.dart";

abstract class IOverviewViewModel extends ChangeNotifier {
  DateTime get today;

  int get targetEnergy;

  double get currentWeight;
  set currentWeight(double amount);

  double get targetWeight;
  set targetWeight(double target);

  int get currentEnergyTotal;

  EnergyUnit get energyUnit;
  WeightUnit get weightUnit;

  List<Weight> getLatest(int days);

  List<Weight> get recentDailyWeights;
  double? get maximumRecentWeight;
  double? get minimumRecentWeight;

  void addEnergyRecord(double amount, DateTime dateTime);
  void addWeightRecord(double amount, DateTime dateTime);

  double get weightMinSelectable;
  double get weightMaxSelectable;

  DateTime get minChartDate;
  DateTime get maxChartDate;

  double get energyCurrentTotalClamped;
}
