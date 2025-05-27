import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';
import 'dart:io';
import 'dart:async';

class StorageTab extends StatefulWidget {
  const StorageTab({super.key});

  @override
  State<StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<StorageTab> {
  bool _isLoading = true;
  late Directory? _externalDir;
  late Directory _tempDir;
  late Directory _appDocDir;
  late Directory _appSupportDir;
  late Directory _appCacheDir;
  int _totalSpace = 0;
  int _freeSpace = 0;

  @override
  void initState() {
    super.initState();
    _getStorageInfo();
  }

  Future<void> _getStorageInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _tempDir = await getTemporaryDirectory();
      _appDocDir = await getApplicationDocumentsDirectory();
      _appSupportDir = await getApplicationSupportDirectory();
      _appCacheDir = await getApplicationCacheDirectory();
      
      try {
        _externalDir = await getExternalStorageDirectory();
      } catch (e) {
        _externalDir = null;
      }

      // This is a simplified approach and may not work on all devices
      if (_externalDir != null) {
        final statFs = await File('${_externalDir!.path}/stat').create();
        final stat = await statFs.stat();
        _totalSpace = stat.size;
        _freeSpace = _totalSpace ~/ 3; // Just an estimate for demo purposes
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
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
              title: const Text('Storage Information'),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _getStorageInfo,
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
                if (_externalDir != null)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Storage Usage',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Icon(
                                  Icons.storage,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            LinearProgressIndicator(
                              value: _totalSpace > 0 ? (_totalSpace - _freeSpace) / _totalSpace : 0,
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              color: Theme.of(context).colorScheme.primary,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Used: ${_formatBytes(_totalSpace - _freeSpace)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  'Free: ${_formatBytes(_freeSpace)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total: ${_formatBytes(_totalSpace)}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
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
                    title: 'App Storage Paths',
                    icon: Icons.folder,
                    children: [
                      InfoItem(
                        title: 'App Documents',
                        value: _appDocDir.path,
                      ),
                      InfoItem(
                        title: 'App Cache',
                        value: _appCacheDir.path,
                      ),
                      InfoItem(
                        title: 'App Support',
                        value: _appSupportDir.path,
                      ),
                      InfoItem(
                        title: 'Temporary',
                        value: _tempDir.path,
                      ),
                      if (_externalDir != null)
                        InfoItem(
                          title: 'External Storage',
                          value: _externalDir!.path,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Storage Information',
                    icon: Icons.sd_storage,
                    children: [
                      InfoItem(
                        title: 'Note',
                        value: 'Detailed storage information like filesystem type, mount points, and partition details requires root access on most Android devices.',
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
