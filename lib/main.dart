import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/models/day.dart";
import "package:snacktrack/src/models/energy.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/models/theme_setting.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/models/weight_unit.dart";

import "src/app.dart";

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(EnergyAdapter());
  Hive.registerAdapter(WeightAdapter());
  Hive.registerAdapter(EnergyUnitAdapter());
  Hive.registerAdapter(WeightUnitAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(DayAdapter());

  final energyBox = await Hive.openBox<Energy>("Energy");
  final weightBox = await Hive.openBox<Weight>("Weight");
  final settingsBox = await Hive.openBox<dynamic>("Settings");

  runApp(App(
    energyBox: energyBox,
    weightBox: weightBox,
    settingsBox: settingsBox,
  ));
}
