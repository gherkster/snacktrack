import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/app.dart";

class DeviceThemeOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: SettingsList(
        //   sections: [
        //     SettingsSection(
        //       tiles: [
        //         SettingsTile(
        //           title: "System theme",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ThemeNotifier>(context, listen: false).themeMode = ThemeMode.system;
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //         SettingsTile(
        //           title: "Light theme",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ThemeNotifier>(context, listen: false).themeMode = ThemeMode.light;
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //         SettingsTile(
        //           title: "Dark theme",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ThemeNotifier>(context, listen: false).themeMode = ThemeMode.dark;
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        );
  }
}
