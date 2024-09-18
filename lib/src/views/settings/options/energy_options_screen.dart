import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class EnergyOptionsScreen extends StatelessWidget {
  const EnergyOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ISettingsViewmodel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const BigHeading(title: "Energy units"),
                ListTile(
                  title: const Text("Kilojoules"),
                  onTap: () {
                    model.energyUnit = EnergyUnit.kilojoules;
                  },
                  trailing: model.energyUnit == EnergyUnit.kilojoules ? const Icon(Icons.check) : null,
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: const Text("Calories"),
                  onTap: () {
                    model.energyUnit = EnergyUnit.calories;
                    Provider.of<ISettingsViewmodel>(context, listen: false).energyUnit = EnergyUnit.calories;
                  },
                  trailing: model.energyUnit == EnergyUnit.calories ? const Icon(Icons.check) : null,
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
