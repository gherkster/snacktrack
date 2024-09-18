import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/viewmodels/settings_viewmodel.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class WeightOptionsScreen extends StatelessWidget {
  const WeightOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const BigHeading(title: "Weight units"),
                ListTile(
                  title: const Text("Kilograms"),
                  onTap: () {
                    model.weightUnit = WeightUnit.kilograms;
                  },
                  trailing: model.weightUnit == WeightUnit.kilograms ? const Icon(Icons.check) : null,
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: const Text("Pounds"),
                  onTap: () {
                    model.weightUnit = WeightUnit.pounds;
                    Provider.of<SettingsViewModel>(context, listen: false).energyUnit = EnergyUnit.calories;
                  },
                  trailing: model.weightUnit == WeightUnit.pounds ? const Icon(Icons.check) : null,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
