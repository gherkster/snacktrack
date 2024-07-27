import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";

class EnergyOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: SettingsList(
        //   sections: [
        //     SettingsSection(
        //       tiles: [
        //         SettingsTile(
        //           title: "Kilojoules",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ISettingsViewmodel>(context, listen: false).energyUnit = EnergyUnit.kj;
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //         SettingsTile(
        //           title: "Calories",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ISettingsViewmodel>(context, listen: false).energyUnit = EnergyUnit.cal;
        //             Navigator.of(context).pop();
        //           },
        //         )
        //       ],
        //     ),
        //   ],
        // ),
        );
  }
}
