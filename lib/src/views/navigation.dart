import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sliding_up_panel/sliding_up_panel.dart";
import "package:snacktrack/src/models/energy_unit.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_navigation_viewmodel.dart";

import "history/history_view.dart";
import "overview/overview_view.dart";
import "settings/settings_view.dart";

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

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
        panel: Column(
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
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Overview"),
                  BottomNavigationBarItem(icon: Icon(Icons.event_note), label: "History"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
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
                        Consumer<INavigationViewModel>(
                          builder: (context, model, child) {
                            return Expanded(
                              child: TextFormField(
                                controller: _textEditingController,
                                focusNode: _energyInputFocus,
                                style: const TextStyle(fontSize: 24),
                                textInputAction: TextInputAction.send,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(),
                                  labelText: model.energyUnit == EnergyUnit.kj ? "Energy" : "Calories",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onFieldSubmitted: (energy) {
                                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                    model.energyAddRecord(double.parse(energy));

                                    _textEditingController.clear();
                                    _panelController.close();
                                  }
                                },
                                validator: (value) => model.validator(value),
                                keyboardType: TextInputType.number,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        onPanelSlide: (double pos) => setState(() {
          if (pos < 0.9) {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        }),
      ),
    );
  }
}
