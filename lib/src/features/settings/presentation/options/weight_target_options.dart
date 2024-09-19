import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class WeightTargetOptions extends StatelessWidget {
  const WeightTargetOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, service, child) {
        return AlertDialog(
          title: const Text("Target weight"),
          content: DecimalNumberPicker(
            minValue: service.weightUnit == WeightUnit.kilograms ? 50 : 100,
            maxValue: service.weightUnit == WeightUnit.kilograms ? 200 : 400,
            value: service.targetWeight,
            onChanged: (value) => service.targetWeight = value,
            itemWidth: 64,
          ),
        );
      },
    );
  }
}
