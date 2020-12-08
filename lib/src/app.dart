import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';
import 'package:snacktrack/src/repositories/settings_repository.dart';
import 'package:provider/provider.dart';

import 'repositories/energy_repository.dart';
import 'repositories/interfaces/i_energy_repository.dart';
import 'repositories/weight_repository.dart';
import 'views/navigation_view.dart';

class App extends StatelessWidget {
  final Box energyBox;
  final Box weightBox;
  final Box settingsBox;

  const App({Key key, @required this.energyBox, @required this.weightBox, @required this.settingsBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IEnergyRepository>(create: (_) => EnergyRepository(energyBox)),
        Provider<IWeightRepository>(create: (_) => WeightRepository(weightBox)),
        Provider<ISettingsRepository>(create: (_) => SettingsRepository(settingsBox)),
      ],
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (context) => ThemeNotifier(Provider.of<ISettingsRepository>(context, listen: false)),
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
