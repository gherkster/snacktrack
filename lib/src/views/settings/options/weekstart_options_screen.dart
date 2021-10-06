import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:snacktrack/src/app.dart';
import 'package:snacktrack/src/models/day.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart';

class WeekStartOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: "Monday",
                onPressed: (BuildContext context) {
                  Provider.of<ISettingsViewmodel>(context, listen: false).weekStart = Day.monday;
                  Navigator.of(context).pop();
                },
              ),
              SettingsTile(
                title: "Saturday",
                onPressed: (BuildContext context) {
                  Provider.of<ISettingsViewmodel>(context, listen: false).weekStart = Day.saturday;
                  Navigator.of(context).pop();
                },
              ),
              SettingsTile(
                title: "Sunday",
                onPressed: (BuildContext context) {
                  Provider.of<ISettingsViewmodel>(context, listen: false).weekStart = Day.sunday;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
