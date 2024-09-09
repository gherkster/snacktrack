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
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "Overview",
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note),
            label: "History",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        selectedIndex: _selectedTabIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      body: SingleChildScrollView(
        child: _availableTabs[_selectedTabIndex],
      ),
    );
  }
}
