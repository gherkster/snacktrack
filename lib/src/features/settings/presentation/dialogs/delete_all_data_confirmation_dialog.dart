import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class DeleteAllDataConfirmationDialog extends StatelessWidget {
  const DeleteAllDataConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settingsService, child) {
        return AlertDialog(
          title: const Text("Delete all data"),
          content: const Text(
            "All health data will be deleted from the app. User preferences will be reset to the default settings.",
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
              child: Text('Delete',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error)),
              onPressed: () async {
                await settingsService.deleteDeviceData();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
