import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class DeleteAllDataConfirmationOptions extends StatelessWidget {
  const DeleteAllDataConfirmationOptions({super.key});

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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                settingsService.deleteDeviceData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
