import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/meals/domain/food.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";
import "package:snacktrack/src/utilities/unit_conversion.dart";

class FoodWeightDialog extends StatefulWidget {
  const FoodWeightDialog({super.key, required this.initialQuantity, required this.food, required this.onConfirm});

  final int initialQuantity;
  final Food food;
  final void Function(int quantity) onConfirm;

  @override
  State<FoodWeightDialog> createState() => _CreateFoodWeightDialogState();
}

class _CreateFoodWeightDialogState extends State<FoodWeightDialog> {
  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();

    final quantityController = TextEditingController();
    quantityController.text = widget.initialQuantity.toString();

    return AlertDialog(
      title: Text(widget.food.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Weight"),
              Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: TextFormField(
                      controller: quantityController,
                      autofocus: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text("g"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Energy per 100g"),
              Row(
                children: [
                  Text(convertKilojoulesToPreferredUnits(widget.food.kilojoulesPer100g, settingsService.energyUnit)
                      .toString()),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(settingsService.energyUnit.shortName),
                ],
              ),
            ],
          ),
        ],
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
            child: Text(
              "Save",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            onPressed: () => widget.onConfirm(int.parse(quantityController.text))),
      ],
    );
  }
}
