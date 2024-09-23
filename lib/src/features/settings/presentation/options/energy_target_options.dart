import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class EnergyTargetOptions extends StatefulWidget {
  const EnergyTargetOptions({super.key, required this.targetEnergy});

  // Use a stateful widget to track the new in-progress target value,
  // as modifying the provider state directly on input would lead to the overview page
  // rebuilding every frame as the picker is scrolled, due to the IndexedStack
  final int targetEnergy;

  @override
  State<EnergyTargetOptions> createState() => _EnergyTargetOptionsState();
}

class _EnergyTargetOptionsState extends State<EnergyTargetOptions> {
  late int targetEnergy = widget.targetEnergy;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(builder: (context, service, child) {
      return AlertDialog(
        title: const Text("Target energy intake"),
        content: NumberPicker(
          minValue: service.energyUnit == EnergyUnit.kilojoules ? 4000 : 1000,
          maxValue: service.energyUnit == EnergyUnit.kilojoules ? 20000 : 5000,
          value: targetEnergy,
          onChanged: (value) => setState(() => targetEnergy = value),
          step: service.energyUnit == EnergyUnit.kilojoules ? 100 : 25,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text('Confirm', style: Theme.of(context).textTheme.bodyMedium),
            onPressed: () {
              service.targetEnergy = targetEnergy;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
