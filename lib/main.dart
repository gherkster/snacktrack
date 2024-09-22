import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:snacktrack/objectbox.g.dart";
import "package:snacktrack/src/features/health/data/models/energy_intake_measurement_dto.dart";
import "package:snacktrack/src/features/health/data/models/weight_measurement_dto.dart";

import "src/app.dart";

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  final Store store = await openStore();
  final energyBox = store.box<EnergyIntakeMeasurementDto>();
  final weightBox = store.box<WeightMeasurementDto>();

  final sharedPreferences =
      await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());

  runApp(App(
    energyBox: energyBox,
    weightBox: weightBox,
    sharedPreferences: sharedPreferences,
  ));
}
