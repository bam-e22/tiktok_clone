import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final screens = [
    Center(
      child: Text('Home'),
    ),
    Center(
      child: Text('Search'),
    ),
    Center(
      child: Text('Third'),
    ),
    Center(
      child: Text('Third'),
    ),
    Center(
      child: Text('Third'),
    ),
  ];

  void _onDestinationTap(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationTap,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: Colors.teal,
            ),
            label: 'Home',
            tooltip: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.amber,
            ),
            label: 'Search',
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }
}
