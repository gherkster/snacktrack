import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class WeightUnitOptions extends StatelessWidget {
  const WeightUnitOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, service, child) {
        return AlertDialog(
          title: const Text("Weight units"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Kilograms"),
                onTap: () {
                  service.weightUnit = WeightUnit.kilograms;
                },
                trailing: service.weightUnit == WeightUnit.kilograms ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title: const Text("Pounds"),
                onTap: () {
                  service.weightUnit = WeightUnit.pounds;
                },
                trailing: service.weightUnit == WeightUnit.pounds ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
