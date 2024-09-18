import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

import "options/theme_options.dart";
import "options/energy_unit_options.dart";
import "options/weight_unit_options.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  final sectionPadding = const EdgeInsets.only(top: 24);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BigHeading(title: "Settings"),
                Padding(
                  padding: sectionPadding,
                  child: const Text("Units"),
                ),
                ListTile(
                  title: const Text("Energy units"),
                  subtitle: Text(model.energyUnit.longName),
                  contentPadding: EdgeInsets.zero,
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EnergyOptionsScreen(),
                      ),
                    ),
                  },
                ),
                ListTile(
                  title: const Text("Weight units"),
                  subtitle: Text(model.weightUnit.longName),
                  contentPadding: EdgeInsets.zero,
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeightOptionsScreen(),
                      ),
                    ),
                  },
                ),
                Padding(
                  padding: sectionPadding,
                  child: const Text("Targets"),
                ),
                ListTile(
                  title: const Text("Energy daily target"),
                  // TODO Hardcoded until finalized unit conversion is implemented
                  subtitle: Text(model.energyUnit == EnergyUnit.kilojoules ? "999 KJ" : "333 Cal"),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: const Text("Weight daily target"),
                  subtitle: Text(model.weightUnit == WeightUnit.kilograms ? "99 KG" : "199 lb"),
                  contentPadding: EdgeInsets.zero,
                ),
                Padding(
                  padding: sectionPadding,
                  child: const Text("Device"),
                ),
                ListTile(
                  title: const Text("Theme"),
                  subtitle: Text(
                    model.themeMode == ThemeMode.system
                        ? "System theme"
                        : model.themeMode == ThemeMode.dark
                            ? "Dark theme"
                            : "Light theme",
                  ),
                  contentPadding: EdgeInsets.zero,
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeviceThemeOptionsScreen(),
                      ),
                    ),
                  },
                ),
                ListTile(
                  title: Text("Delete all data"),
                  contentPadding: EdgeInsets.zero,
                  // TODO: Add confirmation
                  onTap: () => model.deleteDeviceData(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
