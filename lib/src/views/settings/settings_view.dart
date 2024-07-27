import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/day.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";

import "options/devicetheme_options_screen.dart";
import "options/energy_options_screen.dart";
import "options/weekstart_options_screen.dart";
import "options/weight_options_screen.dart";

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ErrorWidget(Exception());
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<ISettingsViewmodel>(
  //     builder: (context, model, child) {
  //       return SettingsList(
  //         sections: [
  //           SettingsSection(
  //             title: "Units",
  //             tiles: [
  //               SettingsTile(
  //                 title: "Energy",
  //                 subtitle: model.energyUnit == EnergyUnit.kj ? "Kilojoules" : "Calories",
  //                 onPressed: (BuildContext context) {
  //                   Navigator.of(context).push<void>(
  //                     MaterialPageRoute(builder: (_) => EnergyOptionsScreen()),
  //                   );
  //                 },
  //               ),
  //               SettingsTile(
  //                 title: "Weight",
  //                 subtitle: model.weightUnit == WeightUnit.kg ? "Kilograms" : "Pounds",
  //                 onPressed: (BuildContext context) {
  //                   Navigator.of(context).push<void>(
  //                     MaterialPageRoute(builder: (_) => WeightOptionsScreen()),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //           SettingsSection(
  //             title: "Targets",
  //             tiles: [
  //               // TODO Hardcoded until finalized unit conversion is implemented
  //               SettingsTile(
  //                 title: "Energy",
  //                 subtitle: model.energyUnit == EnergyUnit.kj ? "999 KJ" : "333 Cal",
  //               ),
  //               SettingsTile(
  //                 title: "Weight",
  //                 subtitle: model.weightUnit == WeightUnit.kg ? "99 KG" : "199 lb",
  //               )
  //             ],
  //           ),
  //           SettingsSection(
  //             title: "Device",
  //             tiles: [
  //               SettingsTile(
  //                 title: "Theme",
  //                 subtitle: model.themeMode == ThemeMode.system
  //                     ? "System theme"
  //                     : model.themeMode == ThemeMode.dark
  //                         ? "Dark theme"
  //                         : "Light theme",
  //                 onPressed: (BuildContext context) {
  //                   Navigator.of(context).push<void>(
  //                     MaterialPageRoute(builder: (_) => DeviceThemeOptionsScreen()),
  //                   );
  //                 },
  //               ),
  //               SettingsTile(
  //                 title: "Start of week",
  //                 subtitle: model.weekStart == Day.monday
  //                     ? "Monday"
  //                     : model.weekStart == Day.saturday
  //                         ? "Saturday"
  //                         : "Sunday",
  //                 onPressed: (BuildContext context) {
  //                   Navigator.of(context).push<void>(
  //                     MaterialPageRoute(builder: (_) => WeekStartOptionsScreen()),
  //                   );
  //                 },
  //               ),
  //               SettingsTile(
  //                 // TODO Add confirmation
  //                 title: "Delete data",
  //                 onPressed: (BuildContext context) {
  //                   model.deleteDeviceData();
  //                 },
  //               )
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}

/*
SettingSection(
            SettingRadioItem<Day>(
              title: 'Start of the week',
              displayValue: _settingsViewModel.weekStart == Day.monday
                  ? 'Monday'
                  : _settingsViewModel.weekStart == Day.saturday
                      ? 'Saturday'
                      : 'Sunday',
              selectedValue: _settingsViewModel.weekStart,
              items: [
                SettingRadioValue<Day>('Monday', Day.monday),
                SettingRadioValue<Day>('Saturday', Day.saturday),
                SettingRadioValue<Day>('Sunday', Day.sunday),
              ],
              onChanged: (setting) => setState(() => _settingsViewModel.weekStart = setting),
            )
          ],
        )
      ],
    );
  }
}
 */