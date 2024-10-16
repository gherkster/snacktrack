import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class EnergyTargetDialog extends StatefulWidget {
  const EnergyTargetDialog({super.key, required this.targetEnergy});

  // Use a stateful widget to track the new in-progress target value,
  // as modifying the provider state directly on input would lead to the overview page
  // rebuilding every frame as the picker is scrolled, due to the IndexedStack
  final int targetEnergy;

  @override
  State<EnergyTargetDialog> createState() => _EnergyTargetDialogState();
}

class _EnergyTargetDialogState extends State<EnergyTargetDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final energyTargetInputController = TextEditingController();

  @override
  void initState() {
    energyTargetInputController.text = widget.targetEnergy.toString();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(builder: (context, service, child) {
      return AlertDialog(
        title: const Text("Target energy intake"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Daily limit"),
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: energyTargetInputController,
                      autofocus: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Required";
                        }

                        final numberValue = int.parse(value);
                        if (numberValue < (service.energyUnit == EnergyUnit.kilojoules ? 4000 : 1000)) {
                          return "Too low";
                        }

                        if (numberValue > (service.energyUnit == EnergyUnit.kilojoules ? 20000 : 5000)) {
                          return "Too high";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                Text(service.energyUnit.shortName),
              ],
            ),
          ],
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
              if (formKey.currentState?.validate() == false) {
                return;
              }

              var energyTarget = int.tryParse(energyTargetInputController.text);
              // Energy should always be valid as the keyboard filter only allows for integer input
              // However we should still avoid storing empty values
              if (energyTarget != null && energyTarget > 0) {
                service.targetEnergy = energyTarget;
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
