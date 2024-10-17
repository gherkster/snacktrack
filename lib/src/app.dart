import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:objectbox/objectbox.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:snacktrack/src/features/meals/data/food_repository.dart";
import "package:snacktrack/src/features/meals/data/meal_repository.dart";
import "package:snacktrack/src/features/meals/services/meal_service.dart";
import "package:snacktrack/src/features/settings/data/settings_repository.dart";
import "package:snacktrack/src/features/health/services/health_service.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";

import "features/health/data/energy_repository.dart";
import "features/health/data/weight_repository.dart";
import "routing/navigation.dart";

class App extends StatelessWidget {
  final Store store;
  final SharedPreferencesWithCache sharedPreferences;

  const App({
    super.key,
    required this.store,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final energyRepository = EnergyRepository(store);
    final weightRepository = WeightRepository(store);
    final mealRepository = MealRepository(store);
    final foodRepository = FoodRepository(store);
    final settingsRepository = SettingsRepository(sharedPreferences);

    final currentFoodDatabaseHash = settingsRepository.getFoodDatabaseHash();
    foodRepository.getLatestDatabaseHash().then((hash) {
      if (currentFoodDatabaseHash != hash) {
        // Load default foods from dataset asynchronously
        foodRepository.loadDatasetFoods().then((_) {
          settingsRepository.setFoodDatabaseHash(hash);
        });
      }
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HealthService>(
          create: (_) => HealthService(energyRepository, weightRepository, settingsRepository),
        ),
        ChangeNotifierProvider<MealService>(
          create: (_) => MealService(mealRepository, foodRepository),
        ),
        ChangeNotifierProvider<SettingsService>(
          create: (_) => SettingsService(energyRepository, weightRepository, settingsRepository),
        ),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settingsService, child) => MaterialApp(
          home: const NavBar(),
          theme: ThemeData(
            fontFamily: GoogleFonts.openSans().fontFamily,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
            ).copyWith(
              surface: Colors.grey[50],
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.openSans().fontFamily,
            colorSchemeSeed: Colors.deepPurple,
          ),
          themeMode: settingsService.themeMode,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
