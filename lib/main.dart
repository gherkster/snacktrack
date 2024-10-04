import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:snacktrack/objectbox.g.dart";

import "src/app.dart";

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  final Store store = await openStore();
  final sharedPreferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  runApp(App(
    store: store,
    sharedPreferences: sharedPreferences,
  ));
}
