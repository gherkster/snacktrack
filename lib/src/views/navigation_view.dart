import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/viewmodels/navigation_viewmodel.dart';
import 'package:snacktrack/src/repositories/interfaces/i_energy_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';
import 'package:snacktrack/src/views/settings_view.dart';

import 'history_view.dart';
import 'overview_view.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static final PanelController _panelController = PanelController();
  static final FocusNode _energyInputFocus = FocusNode();
  static final TextEditingController _textEditingController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();

  int _selectedTabIndex = 0;
  final List<Widget> _availableTabs = [OverviewScreen(), HistoryScreen(), SettingsScreen()];
  NavigationViewModel _navigationViewModel;

  @override
  void didChangeDependencies() {
    if (_navigationViewModel == null) {
      final energyRepository = Provider.of<IEnergyRepository>(context);
      final weightRepository = Provider.of<IWeightRepository>(context);
      final settingsRepository = Provider.of<ISettingsRepository>(context);

      _navigationViewModel = NavigationViewModel(energyRepository, weightRepository, settingsRepository);
    }
  }

  @override
  void dispose() {
    _energyInputFocus.dispose();
    _panelController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SlidingUpPanel(
        maxHeight: 450.0, // TODO calculate
        minHeight: 95.0,
        controller: _panelController,
        onPanelOpened: () => setState(() {
          FocusScope.of(context).requestFocus(_energyInputFocus);
        }),
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        body: SafeArea(
          child: Scaffold(
            body: _availableTabs.elementAt(_selectedTabIndex),
          ),
        ),
        panel: _panel(),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        onPanelSlide: (double pos) => setState(() {
          if (pos < 0.9) {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus.unfocus();
          }
        }),
      ),
    );
  }

  Widget _panel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            )
          ],
        ),
        const SizedBox(height: 18.0),
        BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Overview'),
              BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
            currentIndex: _selectedTabIndex,
            selectedItemColor: Colors.red[800],
            onTap: (int index) => setState(() => _selectedTabIndex = index)),
        const SizedBox(height: 36.0),
        Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textEditingController,
                        focusNode: _energyInputFocus,
                        style: const TextStyle(fontSize: 24),
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(),
                          labelText: _navigationViewModel.energyUnit == EnergyUnit.kj ? "Energy" : "Calories",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onFieldSubmitted: (energy) {
                          if (_formKey.currentState.validate()) {
                            _navigationViewModel.energyAddRecord(double.parse(energy));

                            _textEditingController.clear();
                            _panelController.close();
                          }
                        },
                        validator: (value) => _navigationViewModel.validator(value),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
