import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

class DeviceThemeOptions extends StatelessWidget {
  const DeviceThemeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();
    return Consumer<SettingsService>(
      builder: (context, themeService, child) {
        return AlertDialog(
          title: const Text("Theme"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("System theme"),
                onTap: () {
                  themeService.themeMode = ThemeMode.system;
                },
                trailing: settingsService.themeMode == ThemeMode.system ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title: const Text("Light theme"),
                onTap: () {
                  themeService.themeMode = ThemeMode.light;
                },
                trailing: settingsService.themeMode == ThemeMode.light ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title: const Text("Dark theme"),
                onTap: () {
                  themeService.themeMode = ThemeMode.dark;
                },
                trailing: settingsService.themeMode == ThemeMode.dark ? const Icon(Icons.check) : null,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
