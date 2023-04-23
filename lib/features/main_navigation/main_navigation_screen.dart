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

  void _onTap(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              label: "Home",
              tooltip: "Home",
              backgroundColor: Colors.amber),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
              label: "Search",
              tooltip: "Search",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.apple),
              label: "Apple",
              tooltip: "Apple",
              backgroundColor: Colors.cyan),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.airbnb),
              label: "Airbnb",
              tooltip: "Airbnb",
              backgroundColor: Colors.yellow),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.adversal),
              label: "Adversal",
              tooltip: "Adversal",
              backgroundColor: Colors.green),
        ],
      ),
    );
  }
}
