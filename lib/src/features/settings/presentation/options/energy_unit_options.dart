import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class EnergyUnitOptions extends StatelessWidget {
  const EnergyUnitOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, service, child) {
        return AlertDialog(
          title: const Text("Energy units"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Kilojoules"),
                onTap: () {
                  service.energyUnit = EnergyUnit.kilojoules;
                },
                trailing: service.energyUnit == EnergyUnit.kilojoules ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title: const Text("Calories"),
                onTap: () {
                  service.energyUnit = EnergyUnit.calories;
                  Provider.of<SettingsService>(context, listen: false).energyUnit = EnergyUnit.calories;
                },
                trailing: service.energyUnit == EnergyUnit.calories ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
