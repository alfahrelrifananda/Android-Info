import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _isDarkMode = false;
  bool _isSystemTheme = true;
  bool _isLoading = true;
  PackageInfo? _packageInfo;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadPackageInfo();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSystemTheme = prefs.getBool('isSystemTheme') ?? true;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isLoading = false;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSystemTheme', _isSystemTheme);
    await prefs.setBool('isDarkMode', _isDarkMode);
  }
  
  Future<void> _loadPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
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
              title: const Text('Settings'),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: _packageInfo?.appName ?? 'Device Info',
                    applicationVersion: _packageInfo?.version ?? '1.0.0',
                    applicationIcon: const Icon(Icons.phone_android, size: 48),
                    children: [
                      const Text(
                        'A comprehensive device information app that displays detailed hardware and software information about your Android device.',
                      ),
                    ],
                  );
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
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.palette,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Appearance',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Use System Theme'),
                            subtitle: const Text('Follow system dark/light mode settings'),
                            value: _isSystemTheme,
                            onChanged: (value) {
                              setState(() {
                                _isSystemTheme = value;
                                if (!value) {
                                  // If not using system theme, use the current dark mode setting
                                  _isDarkMode = Theme.of(context).brightness == Brightness.dark;
                                }
                              });
                              _saveSettings();
                            },
                          ),
                          if (!_isSystemTheme)
                            SwitchListTile(
                              title: const Text('Dark Mode'),
                              subtitle: const Text('Enable dark theme'),
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() {
                                  _isDarkMode = value;
                                });
                                _saveSettings();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'About',
                    icon: Icons.info_outline,
                    children: [
                      InfoItem(
                        title: 'App Name',
                        value: _packageInfo?.appName ?? 'Device Info',
                      ),
                      InfoItem(
                        title: 'Version',
                        value: _packageInfo?.version ?? '1.0.0',
                      ),
                      InfoItem(
                        title: 'Build Number',
                        value: _packageInfo?.buildNumber ?? '1',
                      ),
                      InfoItem(
                        title: 'Package Name',
                        value: _packageInfo?.packageName ?? 'com.example.device_info_app',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.link,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Links',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined),
                            title: const Text('Privacy Policy'),
                            onTap: () {
                              launchUrl(Uri.parse('https://example.com/privacy'));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.description_outlined),
                            title: const Text('Terms of Service'),
                            onTap: () {
                              launchUrl(Uri.parse('https://example.com/terms'));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.star_outline),
                            title: const Text('Rate App'),
                            onTap: () {
                              launchUrl(Uri.parse('market://details?id=${_packageInfo?.packageName}'));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.share_outlined),
                            title: const Text('Share App'),
                            onTap: () {
                              // Share functionality would be implemented here
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
