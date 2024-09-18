import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:snacktrack/src/features/health/domain/energy.dart";
import "package:snacktrack/src/features/health/domain/energy_unit.dart";
import "package:snacktrack/src/features/settings/domain/theme_setting.dart";
import "package:snacktrack/src/features/health/domain/weight.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";

import "src/app.dart";

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(EnergyAdapter());
  Hive.registerAdapter(WeightAdapter());
  Hive.registerAdapter(EnergyUnitAdapter());
  Hive.registerAdapter(WeightUnitAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

  final energyBox = await Hive.openBox<Energy>("Energy");
  final weightBox = await Hive.openBox<Weight>("Weight");
  final settingsBox = await Hive.openBox<dynamic>("Settings");

  runApp(App(
    energyBox: energyBox,
    weightBox: weightBox,
    settingsBox: settingsBox,
  ));
}
