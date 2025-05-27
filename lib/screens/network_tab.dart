import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';
import 'dart:async';

class NetworkTab extends StatefulWidget {
  const NetworkTab({super.key});

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab> {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = 
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      setState(() {
        _connectionStatus = result as ConnectivityResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  String _getConnectionTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }

  IconData _getConnectionIcon(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectivityResult.ethernet:
        return Icons.lan;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.vpn:
        return Icons.vpn_key;
      case ConnectivityResult.none:
        return Icons.signal_wifi_off;
      default:
        return Icons.device_unknown;
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
              title: const Text('Network Information'),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initConnectivity,
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
                            _getConnectionIcon(_connectionStatus),
                            size: 80,
                            color: _connectionStatus == ConnectivityResult.none
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getConnectionTypeString(_connectionStatus),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _connectionStatus == ConnectivityResult.none
                                ? 'Not Connected'
                                : 'Connected',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: _connectionStatus == ConnectivityResult.none
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Connection Details',
                    icon: Icons.info_outline,
                    children: [
                      InfoItem(
                        title: 'Connection Type',
                        value: _getConnectionTypeString(_connectionStatus),
                      ),
                      InfoItem(
                        title: 'Status',
                        value: _connectionStatus == ConnectivityResult.none
                            ? 'Disconnected'
                            : 'Connected',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Network Information',
                    icon: Icons.network_check,
                    children: [
                      InfoItem(
                        title: 'Note',
                        value: 'Detailed network information like IP address, MAC address, and signal strength requires additional permissions and may not be available on all devices.',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'WiFi Information',
                    icon: Icons.wifi,
                    children: [
                      InfoItem(
                        title: 'Note',
                        value: 'WiFi details like SSID, signal strength, and frequency require location permissions on modern Android devices.',
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
