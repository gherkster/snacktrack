import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";

const double energyConversionFactor = 0.239005736;
const double weightConversionFactor = 2.204622622;

double convertEnergyToKilojoules(int amount, EnergyUnit units) {
  switch (units) {
    case EnergyUnit.calories:
      return amount / energyConversionFactor;
    case EnergyUnit.kilojoules:
      return amount.toDouble();
  }
}

int convertKilojoulesToPreferredUnits(double amount, EnergyUnit preferredUnits) {
  switch (preferredUnits) {
    case EnergyUnit.calories:
      return (amount * energyConversionFactor).round();
    case EnergyUnit.kilojoules:
      return amount.round();
  }
}

double convertWeightToKilograms(double amount, WeightUnit units) {
  switch (units) {
    case WeightUnit.pounds:
      return amount / weightConversionFactor;
    case WeightUnit.kilograms:
      return amount;
  }
}

convertKilogramsToPreferredUnits(double amount, WeightUnit preferredUnits) {
  switch (preferredUnits) {
    case WeightUnit.pounds:
      return (amount * weightConversionFactor).roundToPrecision(1);
    case WeightUnit.kilograms:
      return amount.roundToPrecision(1);
  }
}
