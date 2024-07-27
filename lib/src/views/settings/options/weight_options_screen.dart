import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/weight_unit.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";

class WeightOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: SettingsList(
        //   sections: [
        //     SettingsSection(
        //       tiles: [
        //         SettingsTile(
        //           title: "Kilograms",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ISettingsViewmodel>(context, listen: false).weightUnit = WeightUnit.kg;
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //         SettingsTile(
        //           title: "Pounds",
        //           onPressed: (BuildContext context) {
        //             Provider.of<ISettingsViewmodel>(context, listen: false).weightUnit = WeightUnit.lb;
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
