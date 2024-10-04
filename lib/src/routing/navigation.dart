import "package:flutter/material.dart";
import "package:snacktrack/src/features/meals/presentation/meals_screen.dart";

import "../features/health/presentation/overview_screen.dart";
import "../features/settings/presentation/settings_screen.dart";

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedTabIndex = 0;
  final List<Widget> _availableTabs = [
    OverviewScreen(),
    const MealsScreen(),
    const SettingsScreen(),
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
            icon: Icon(Icons.fastfood),
            label: "Meals",
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
      // Use an indexed stack to avoid widget rebuilds when switching between tabs,
      // by keeping them alive after navigating away
      body: IndexedStack(
        index: _selectedTabIndex,
        children: _availableTabs,
      ),
    );
  }
}
