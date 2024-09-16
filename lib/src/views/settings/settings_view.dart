import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/day.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";

import "options/devicetheme_options_screen.dart";
import "options/energy_options_screen.dart";
import "options/weekstart_options_screen.dart";
import "options/weight_options_screen.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  @override
  Widget build(BuildContext context) {
    return Consumer<ISettingsViewmodel>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: fieldPadding.add(const EdgeInsets.only(bottom: 12)),
                child: Row(
                  children: [Text("Settings", style: Theme.of(context).textTheme.headlineMedium)],
                ),
              ),
              const Divider(),
              const Text("Units"),
              ListTile(
                title: Text("Energy"),
                subtitle: Text(model.energyUnit.longName),
              ),
              ListTile(
                title: Text("Weight"),
                subtitle: Text(model.weightUnit.longName),
              ),
              const Divider(),
              const Text("Targets"),
              ListTile(
                  title: Text("Energy daily target"),
                  // TODO Hardcoded until finalized unit conversion is implemented
                  subtitle: Text(model.energyUnit == EnergyUnit.kilojoules ? "999 KJ" : "333 Cal")),
              ListTile(
                title: Text("Weight daily target"),
                subtitle: Text(model.weightUnit == WeightUnit.kilograms ? "99 KG" : "199 lb"),
              ),
              Divider(),
              Text("Device"),
              ListTile(
                title: Text("Theme"),
                subtitle: Text(
                  model.themeMode == ThemeMode.system
                      ? "System theme"
                      : model.themeMode == ThemeMode.dark
                          ? "Dark theme"
                          : "Light theme",
                ),
              ),
              ListTile(
                title: Text("Delete all data"),
                // TODO: Add confirmation
                onTap: () => model.deleteDeviceData(),
              )
            ],
          ),
        );
      },
    );
  }
}
