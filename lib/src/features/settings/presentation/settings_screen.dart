import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/settings/presentation/dialogs/delete_all_data_confirmation_dialog.dart";
import "package:snacktrack/src/features/settings/presentation/dialogs/energy_target_dialog.dart";
import "package:snacktrack/src/features/settings/presentation/dialogs/energy_unit_dialog.dart";
import "package:snacktrack/src/features/settings/presentation/dialogs/device_theme_dialog.dart";
import "package:snacktrack/src/features/settings/presentation/dialogs/weight_target_dialog.dart";
import "package:snacktrack/src/features/settings/presentation/dialogs/weight_unit_dialog.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";
import "package:snacktrack/src/styles/layout.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final sectionPadding = const EdgeInsets.only(top: Spacing.large);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, model, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
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
                        builder: (BuildContext context) => const EnergyUnitDialog(),
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
                        builder: (BuildContext context) => const WeightUnitDialog(),
                      )
                    },
                  ),
                  Padding(
                    padding: sectionPadding,
                    child: const Text("Targets"),
                  ),
                  ListTile(
                    title: const Text("Target energy intake"),
                    subtitle: Text("${model.targetEnergy} ${model.energyUnit.shortName}"),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => EnergyTargetDialog(targetEnergy: model.targetEnergy),
                      ),
                    },
                  ),
                  ListTile(
                    title: const Text("Target weight"),
                    subtitle: Text("${model.targetWeight} ${model.weightUnit.shortName}"),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => WeightTargetDialog(targetWeight: model.targetWeight),
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
                        builder: (BuildContext context) => const DeviceThemeDialog(),
                      ),
                    },
                  ),
                  ListTile(
                    title: const Text("Delete all data"),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const DeleteAllDataConfirmationDialog(),
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
