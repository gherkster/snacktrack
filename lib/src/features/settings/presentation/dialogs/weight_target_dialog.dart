import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class WeightTargetDialog extends StatefulWidget {
  const WeightTargetDialog({super.key, required this.targetWeight});

  // Use a stateful widget to track the new in-progress target value,
  // as modifying the provider state directly on input would lead to the overview page
  // rebuilding every frame as the picker is scrolled, due to the IndexedStack
  final double targetWeight;

  @override
  State<WeightTargetDialog> createState() => _WeightTargetDialogState();
}

class _WeightTargetDialogState extends State<WeightTargetDialog> {
  late double targetWeight = widget.targetWeight;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, service, child) {
        return AlertDialog(
          title: const Text("Target weight"),
          content: DecimalNumberPicker(
            minValue: service.weightUnit == WeightUnit.kilograms ? 50 : 100,
            maxValue: service.weightUnit == WeightUnit.kilograms ? 200 : 400,
            value: targetWeight,
            onChanged: (value) => setState(() => targetWeight = value),
            itemWidth: 64,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text("Cancel", style: Theme.of(context).textTheme.bodyMedium),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text("Confirm", style: Theme.of(context).textTheme.bodyMedium),
              onPressed: () {
                service.targetWeight = targetWeight;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
