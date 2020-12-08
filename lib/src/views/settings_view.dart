import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/app.dart';
import 'package:snacktrack/src/viewmodels/settings_viewmodel.dart';
import 'package:snacktrack/src/models/day.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/models/weight_unit.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:clean_settings/clean_settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsViewModel _settingsViewModel;

  @override
  void didChangeDependencies() {
    if (_settingsViewModel == null) {
      final settingsRepository = Provider.of<ISettingsRepository>(context);
      _settingsViewModel = SettingsViewModel(settingsRepository);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingContainer(
      sections: [
        SettingSection(
          title: 'Units',
          items: [
            SettingRadioItem<EnergyUnit>(
              title: 'Energy',
              displayValue: _settingsViewModel.energyUnit == EnergyUnit.kj ? 'Kilojoules' : 'Calories',
              selectedValue: _settingsViewModel.energyUnit,
              items: [
                SettingRadioValue<EnergyUnit>('Kilojoules', EnergyUnit.kj),
                SettingRadioValue<EnergyUnit>('Calories', EnergyUnit.cal),
              ],
              onChanged: (setting) => setState(() => _settingsViewModel.energyUnit = setting),
            ),
            SettingRadioItem<WeightUnit>(
              title: 'Weight',
              displayValue: _settingsViewModel.weightUnit == WeightUnit.kg ? 'Kilograms' : 'Pounds',
              selectedValue: _settingsViewModel.weightUnit,
              items: [
                SettingRadioValue<WeightUnit>('Kilograms', WeightUnit.kg),
                SettingRadioValue<WeightUnit>('Pounds', WeightUnit.lb),
              ],
              onChanged: (setting) => setState(() => _settingsViewModel.weightUnit = setting),
            ),
          ],
        ),
        SettingSection(
          title: 'Device',
          items: [
            SettingRadioItem<ThemeMode>(
              title: 'Theme',
              displayValue: _settingsViewModel.themeMode == ThemeMode.light
                  ? 'Light theme'
                  : _settingsViewModel.themeMode == ThemeMode.dark
                      ? 'Dark theme'
                      : 'System theme',
              selectedValue: _settingsViewModel.themeMode,
              items: [
                SettingRadioValue<ThemeMode>('Light', ThemeMode.light),
                SettingRadioValue<ThemeMode>('Dark', ThemeMode.dark),
                SettingRadioValue<ThemeMode>('System', ThemeMode.system),
              ],
              onChanged: (setting) => setState(() {
                Provider.of<ThemeNotifier>(context, listen: false).themeMode = setting;
              }),
            ),
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
