import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class EnergyTargetOptions extends StatelessWidget {
  const EnergyTargetOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(builder: (context, service, child) {
      return AlertDialog(
        title: const Text("Target energy intake"),
        content: NumberPicker(
          minValue: service.energyUnit == EnergyUnit.kilojoules ? 4000 : 1000,
          maxValue: service.energyUnit == EnergyUnit.kilojoules ? 20000 : 5000,
          value: service.targetEnergy,
          onChanged: (value) => service.targetEnergy = value,
          step: service.energyUnit == EnergyUnit.kilojoules ? 100 : 25,
        ),
      );
    });
  }
}
