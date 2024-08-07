import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/repositories/interfaces/i_settings_repository.dart";
import "package:snacktrack/src/repositories/settings_repository.dart";
import "package:snacktrack/src/viewmodels/history_viewmodel.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_history_viewmodel.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";
import "package:snacktrack/src/viewmodels/navigation_viewmodel.dart";
import "package:snacktrack/src/viewmodels/overview_viewmodel.dart";
import "package:snacktrack/src/viewmodels/settings_viewmodel.dart";

import "repositories/energy_repository.dart";
import "repositories/weight_repository.dart";
import "viewmodels/interfaces/i_navigation_viewmodel.dart";
import "viewmodels/interfaces/i_overview_viewmodel.dart";
import "views/navigation.dart";

class App extends StatelessWidget {
  final Box energyBox;
  final Box weightBox;
  final Box settingsBox;

  const App({Key? key, required this.energyBox, required this.weightBox, required this.settingsBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final energyRepository = EnergyRepository(energyBox);
    final weightRepository = WeightRepository(weightBox);
    final settingsRepository = SettingsRepository(settingsBox);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<INavigationViewModel>(create: (_) => NavigationViewModel(energyRepository, weightRepository, settingsRepository)),
        ChangeNotifierProvider<IOverviewViewModel>(create: (_) => OverviewViewModel(energyRepository, weightRepository, settingsRepository)),
        ChangeNotifierProvider<IHistoryViewModel>(create: (_) => HistoryViewModel(energyRepository, weightRepository, settingsRepository)),
        ChangeNotifierProvider<ISettingsViewmodel>(create: (_) => SettingsViewModel(energyRepository, weightRepository, settingsRepository))
      ],
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (context) => ThemeNotifier(settingsRepository),
        child: Consumer<ThemeNotifier>(
          builder: (context, provider, child) => MaterialApp(
            home: const NavBar(),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: Provider.of<ThemeNotifier>(context).themeMode,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  final ISettingsRepository _settingsRepository;
  ThemeNotifier(this._settingsRepository);

  ThemeMode get themeMode => _settingsRepository.themeMode;
  set themeMode(ThemeMode mode) {
    _settingsRepository.themeMode = mode;
    notifyListeners();
  }
}
