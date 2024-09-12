import "package:flutter/material.dart";

import "history/history_view.dart";
import "overview/overview_view.dart";
import "settings/settings_view.dart";

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedTabIndex = 0;
  final List<Widget> _availableTabs = [
    OverviewScreen(),
    HistoryScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      body: _availableTabs[_selectedTabIndex],
    );
  }
}
