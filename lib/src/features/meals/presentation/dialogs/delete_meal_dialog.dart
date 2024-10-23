import "package:flutter/material.dart";

class DeleteMealDialog extends StatelessWidget {
  const DeleteMealDialog({super.key, required this.mealName, required this.onConfirm});

  final String mealName;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete '$mealName'"),
      content: const Text("Are you sure you want to delete this meal?"),
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
          child: Text("Delete",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error)),
          onPressed: () => onConfirm(),
        ),
      ],
    );
  }
}
