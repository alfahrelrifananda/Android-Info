import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';

class DisplayTab extends StatefulWidget {
  const DisplayTab({super.key});

  @override
  State<DisplayTab> createState() => _DisplayTabState();
}

class _DisplayTabState extends State<DisplayTab> {
  @override
  Widget build(BuildContext context) {
    // Get screen metrics
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final physicalWidth = screenWidth * devicePixelRatio;
    final physicalHeight = screenHeight * devicePixelRatio;
    final refreshRate = 60.0; // Default value, actual refresh rate is harder to get
    final brightness = MediaQuery.of(context).platformBrightness;
    final orientation = MediaQuery.of(context).orientation;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Display Information'),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              background: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InfoCard(
                  title: 'Screen Metrics',
                  icon: Icons.monitor,
                  children: [
                    InfoItem(
                      title: 'Logical Resolution',
                      value: '${screenWidth.toStringAsFixed(1)} × ${screenHeight.toStringAsFixed(1)} dp',
                    ),
                    InfoItem(
                      title: 'Physical Resolution',
                      value: '${physicalWidth.toStringAsFixed(0)} × ${physicalHeight.toStringAsFixed(0)} px',
                    ),
                    InfoItem(
                      title: 'Pixel Density',
                      value: '${devicePixelRatio.toStringAsFixed(2)} (${(devicePixelRatio * 160).toStringAsFixed(0)} dpi)',
                    ),
                    InfoItem(
                      title: 'Aspect Ratio',
                      value: '${(screenWidth / screenHeight).toStringAsFixed(2)}:1',
                    ),
                    InfoItem(
                      title: 'Refresh Rate',
                      value: '$refreshRate Hz (estimated)',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InfoCard(
                  title: 'Display Settings',
                  icon: Icons.settings_display,
                  children: [
                    InfoItem(
                      title: 'Theme Mode',
                      value: brightness == Brightness.dark ? 'Dark Mode' : 'Light Mode',
                    ),
                    InfoItem(
                      title: 'Orientation',
                      value: orientation == Orientation.portrait ? 'Portrait' : 'Landscape',
                    ),
                    InfoItem(
                      title: 'Text Scale Factor',
                      value: textScaleFactor.toStringAsFixed(2),
                    ),
                    InfoItem(
                      title: 'Safe Area',
                      value: 'Top: ${MediaQuery.of(context).padding.top.toStringAsFixed(1)} dp\n'
                          'Bottom: ${MediaQuery.of(context).padding.bottom.toStringAsFixed(1)} dp\n'
                          'Left: ${MediaQuery.of(context).padding.left.toStringAsFixed(1)} dp\n'
                          'Right: ${MediaQuery.of(context).padding.right.toStringAsFixed(1)} dp',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InfoCard(
                  title: 'Color Information',
                  icon: Icons.palette,
                  children: [
                    InfoItem(
                      title: 'Color Depth',
                      value: '32-bit (estimated)', // Most modern Android devices use 32-bit color
                    ),
                    InfoItem(
                      title: 'Dynamic Colors',
                      value: Theme.of(context).colorScheme.primary == 
                             ColorScheme.fromSeed(seedColor: Colors.blue).primary
                             ? 'Not Supported' : 'Supported',
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
                              Icons.grid_3x3,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Color Grid',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: 16,
                          itemBuilder: (context, index) {
                            final List<Color> colors = [
                              Colors.red,
                              Colors.pink,
                              Colors.purple,
                              Colors.deepPurple,
                              Colors.indigo,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.cyan,
                              Colors.teal,
                              Colors.green,
                              Colors.lightGreen,
                              Colors.lime,
                              Colors.yellow,
                              Colors.amber,
                              Colors.orange,
                              Colors.deepOrange,
                            ];
                            return Container(
                              decoration: BoxDecoration(
                                color: colors[index],
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            );
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
