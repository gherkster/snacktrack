import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/settings/presentation/options/delete_all_data_confirmation_options.dart";
import "package:snacktrack/src/features/settings/presentation/options/energy_target_options.dart";
import "package:snacktrack/src/features/settings/presentation/options/energy_unit_options.dart";
import "package:snacktrack/src/features/settings/presentation/options/theme_options.dart";
import "package:snacktrack/src/features/settings/presentation/options/weight_target_options.dart";
import "package:snacktrack/src/features/settings/presentation/options/weight_unit_options.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  final sectionPadding = const EdgeInsets.only(top: 24);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, model, child) {
        return Scaffold(
          body: Padding(
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const EnergyUnitOptions(),
                      )
                    },
                  ),
                  ListTile(
                    title: const Text("Weight units"),
                    subtitle: Text(model.weightUnit.longName),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const WeightUnitOptions(),
                      )
                    },
                  ),
                  Padding(
                    padding: sectionPadding,
                    child: const Text("Targets"),
                  ),
                  ListTile(
                    title: const Text("Target energy intake"),
                    subtitle: Text('${model.targetEnergy} ${model.energyUnit.shortName}'),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => EnergyTargetOptions(targetEnergy: model.targetEnergy),
                      ),
                    },
                  ),
                  ListTile(
                    title: const Text("Target weight"),
                    subtitle: Text('${model.targetWeight} ${model.weightUnit.shortName}'),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => WeightTargetOptions(targetWeight: model.targetWeight),
                      ),
                    },
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const DeviceThemeOptions(),
                      ),
                    },
                  ),
                  ListTile(
                    title: const Text("Delete all data"),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const DeleteAllDataConfirmationOptions(),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
