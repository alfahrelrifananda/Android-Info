import 'package:flutter/material.dart';
import '../screens/system_tab.dart';
import '../screens/display_tab.dart';
import '../screens/battery_tab.dart';
// import '../screens/network_tab.dart';
// import '../screens/storage_tab.dart';
// import '../screens/sensors_tab.dart';
import '../screens/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    SystemTab(),
    DisplayTab(),
    BatteryTab(),
    // NetworkTab(),
    // StorageTab(),
    // SensorsTab(),
    SettingsTab(),
  ];

  final List<String> _tabTitles = [
    'Sistem',
    'Tampilan',
    'Baterai',
    // 'Network',
    // 'Storage',
    // 'Sensors',
    'Pengaturan',
  ];

  final List<IconData> _tabIcons = [
    Icons.phone_android,
    Icons.display_settings,
    Icons.battery_full,
    // Icons.wifi,
    // Icons.storage,
    // Icons.sensors,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: List.generate(
          _tabTitles.length,
          (index) => NavigationDestination(
            icon: Icon(_tabIcons[index]),
            label: _tabTitles[index],
          ),
        ),
      ),
    );
  }
}
