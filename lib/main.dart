import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:snacktrack/src/features/health/domain/energy.dart";
import "package:snacktrack/src/features/settings/domain/theme_setting.dart";
import "package:snacktrack/src/features/health/domain/weight.dart";

import "src/app.dart";

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(EnergyAdapter());
  Hive.registerAdapter(WeightAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

  final energyBox = await Hive.openBox<Energy>("Energy");
  final weightBox = await Hive.openBox<Weight>("Weight");

  final sharedPreferences =
      await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());

  runApp(App(
    energyBox: energyBox,
    weightBox: weightBox,
    sharedPreferences: sharedPreferences,
  ));
}
