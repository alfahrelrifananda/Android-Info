import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';

class SystemTab extends StatefulWidget {
  const SystemTab({super.key});

  @override
  State<SystemTab> createState() => _SystemTabState();
}

class _SystemTabState extends State<SystemTab> {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? _androidInfo;
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      _androidInfo = await deviceInfo.androidInfo;
      _packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
              title: const Text('System Information'),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadDeviceInfo();
                },
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
                  child: InfoCard(
                    title: 'Device Information',
                    icon: Icons.smartphone,
                    children: [
                      InfoItem(
                        title: 'Model',
                        value: _androidInfo?.model ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Manufacturer',
                        value: _androidInfo?.manufacturer ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Brand',
                        value: _androidInfo?.brand ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Device',
                        value: _androidInfo?.device ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Product',
                        value: _androidInfo?.product ?? 'Unknown',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'System Information',
                    icon: Icons.memory,
                    children: [
                      InfoItem(
                        title: 'Android Version',
                        value: _androidInfo?.version.release ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'SDK Version',
                        value: _androidInfo?.version.sdkInt.toString() ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Security Patch',
                        value: _androidInfo?.version.securityPatch ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Board',
                        value: _androidInfo?.board ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Hardware',
                        value: _androidInfo?.hardware ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Build ID',
                        value: _androidInfo?.id ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Host',
                        value: _androidInfo?.host ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Type',
                        value: _androidInfo?.type ?? 'Unknown',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'App Information',
                    icon: Icons.info_outline,
                    children: [
                      InfoItem(
                        title: 'App Name',
                        value: _packageInfo?.appName ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Package Name',
                        value: _packageInfo?.packageName ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Version',
                        value: _packageInfo?.version ?? 'Unknown',
                      ),
                      InfoItem(
                        title: 'Build Number',
                        value: _packageInfo?.buildNumber ?? 'Unknown',
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
