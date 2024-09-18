import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/app.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class DeviceThemeOptionsScreen extends StatelessWidget {
  const DeviceThemeOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const BigHeading(title: "Theme"),
                ListTile(
                  title: const Text("System theme"),
                  onTap: () {
                    model.themeMode = ThemeMode.system;
                  },
                  trailing: model.themeMode == ThemeMode.system ? const Icon(Icons.check) : null,
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: const Text("Light theme"),
                  onTap: () {
                    model.themeMode = ThemeMode.light;
                  },
                  trailing: model.themeMode == ThemeMode.light ? const Icon(Icons.check) : null,
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: const Text("Dark theme"),
                  onTap: () {
                    model.themeMode = ThemeMode.dark;
                  },
                  trailing: model.themeMode == ThemeMode.dark ? const Icon(Icons.check) : null,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
