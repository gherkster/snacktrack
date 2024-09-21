import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hive/hive.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/services/health_service.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

import "features/health/data/energy_repository.dart";
import "features/health/data/weight_repository.dart";
import "routing/navigation.dart";

class App extends StatelessWidget {
  final Box energyBox;
  final Box weightBox;
  final SharedPreferencesWithCache sharedPreferences;

  const App({super.key, required this.energyBox, required this.weightBox, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final energyRepository = EnergyRepository(energyBox);
    final weightRepository = WeightRepository(weightBox);
    final settingsRepository = SettingsRepository(sharedPreferences);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HealthService>(
          create: (_) => HealthService(energyRepository, weightRepository, settingsRepository),
        ),
        ChangeNotifierProvider<SettingsService>(
          create: (_) => SettingsService(energyRepository, weightRepository, settingsRepository),
        ),
      ],
      child: Consumer<SettingsService>(
        builder: (context, provider, child) => MaterialApp(
          home: const NavBar(),
          theme: ThemeData(
            fontFamily: GoogleFonts.openSans().fontFamily,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
            ).copyWith(
              surface: Colors.grey[50],
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: Provider.of<SettingsService>(context).themeMode,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
