import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';

class BatteryTab extends StatefulWidget {
  const BatteryTab({super.key});

  @override
  State<BatteryTab> createState() => _BatteryTabState();
}

class _BatteryTabState extends State<BatteryTab> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
      _getBatteryInfo();
    });
  }

  Future<void> _getBatteryInfo() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;
      
      setState(() {
        _batteryLevel = batteryLevel;
        _batteryState = batteryState;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getBatteryStateString(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.unknown:
      default:
        return 'Unknown';
    }
  }

  IconData _getBatteryIcon() {
    if (_batteryState == BatteryState.charging) {
      if (_batteryLevel >= 90) {
        return Icons.battery_full;
      } else if (_batteryLevel >= 60) {
        return Icons.battery_6_bar;
      } else if (_batteryLevel >= 40) {
        return Icons.battery_3_bar;
      } else if (_batteryLevel >= 20) {
        return Icons.battery_2_bar;
      } else {
        return Icons.battery_1_bar;
}
    } else {
      if (_batteryLevel >= 90) {
        return Icons.battery_full;
      } else if (_batteryLevel >= 80) {
        return Icons.battery_6_bar;
      } else if (_batteryLevel >= 60) {
        return Icons.battery_5_bar;
      } else if (_batteryLevel >= 40) {
        return Icons.battery_4_bar;
      } else if (_batteryLevel >= 30) {
        return Icons.battery_3_bar;
      } else if (_batteryLevel >= 20) {
        return Icons.battery_2_bar;
      } else if (_batteryLevel >= 10) {
        return Icons.battery_1_bar;
      } else {
        return Icons.battery_0_bar;
      }
    }
  }

  Color _getBatteryColor() {
    if (_batteryState == BatteryState.charging) {
      return Colors.green;
    } else if (_batteryLevel <= 15) {
      return Colors.red;
    } else if (_batteryLevel <= 30) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Battery Information'),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _getBatteryInfo,
              ),
            ],
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            _getBatteryIcon(),
                            size: 80,
                            color: _getBatteryColor(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$_batteryLevel%',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getBatteryStateString(_batteryState),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 24),
                          LinearProgressIndicator(
                            value: _batteryLevel / 100,
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                            color: _getBatteryColor(),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Battery Status',
                    icon: Icons.battery_unknown,
                    children: [
                      InfoItem(
                        title: 'Battery Level',
                        value: '$_batteryLevel%',
                      ),
                      InfoItem(
                        title: 'State',
                        value: _getBatteryStateString(_batteryState),
                      ),
                      InfoItem(
                        title: 'Power Save Mode',
                        value: 'Unknown', // Requires additional permissions
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Battery Health',
                    icon: Icons.health_and_safety,
                    children: [
                      InfoItem(
                        title: 'Note',
                        value: 'Detailed battery health information requires system permissions and may not be available on all devices.',
                      ),
                    ],
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
