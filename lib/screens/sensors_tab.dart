import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../widgets/info_card.dart';
import '../widgets/info_item.dart';
import 'dart:async';

class SensorsTab extends StatefulWidget {
  const SensorsTab({super.key});

  @override
  State<SensorsTab> createState() => _SensorsTabState();
}

class _SensorsTabState extends State<SensorsTab> {
  AccelerometerEvent _accelerometerEvent = AccelerometerEvent(0, 0, 0, DateTime.now().millisecondsSinceEpoch as DateTime);
  GyroscopeEvent _gyroscopeEvent = GyroscopeEvent(0, 0, 0, DateTime.now().millisecondsSinceEpoch as DateTime);
  MagnetometerEvent _magnetometerEvent = MagnetometerEvent(0, 0, 0, DateTime.now().millisecondsSinceEpoch as DateTime);
  UserAccelerometerEvent _userAccelerometerEvent = UserAccelerometerEvent(0, 0, 0, DateTime.now().millisecondsSinceEpoch as DateTime);
  
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  late StreamSubscription<MagnetometerEvent> _magnetometerSubscription;
  late StreamSubscription<UserAccelerometerEvent> _userAccelerometerSubscription;
  
  bool _isAccelerometerAvailable = true;
  bool _isGyroscopeAvailable = true;
  bool _isMagnetometerAvailable = true;
  bool _isUserAccelerometerAvailable = true;

  @override
  void initState() {
    super.initState();
    _initSensors();
  }

  void _initSensors() {
    try {
      _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerEvent = event;
        });
      }, onError: (e) {
        setState(() {
          _isAccelerometerAvailable = false;
        });
      });
    } catch (e) {
      setState(() {
        _isAccelerometerAvailable = false;
      });
    }

    try {
      _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          _gyroscopeEvent = event;
        });
      }, onError: (e) {
        setState(() {
          _isGyroscopeAvailable = false;
        });
      });
    } catch (e) {
      setState(() {
        _isGyroscopeAvailable = false;
      });
    }

    try {
      _magnetometerSubscription = magnetometerEvents.listen((MagnetometerEvent event) {
        setState(() {
          _magnetometerEvent = event;
        });
      }, onError: (e) {
        setState(() {
          _isMagnetometerAvailable = false;
        });
      });
    } catch (e) {
      setState(() {
        _isMagnetometerAvailable = false;
      });
    }

    try {
      _userAccelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
        setState(() {
          _userAccelerometerEvent = event;
        });
      }, onError: (e) {
        setState(() {
          _isUserAccelerometerAvailable = false;
        });
      });
    } catch (e) {
      setState(() {
        _isUserAccelerometerAvailable = false;
      });
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _gyroscopeSubscription.cancel();
    _magnetometerSubscription.cancel();
    _userAccelerometerSubscription.cancel();
    super.dispose();
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
              title: const Text('Sensors Information'),
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
              if (_isAccelerometerAvailable)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Accelerometer',
                    icon: Icons.speed,
                    children: [
                      InfoItem(
                        title: 'X-Axis',
                        value: _accelerometerEvent.x.toStringAsFixed(2) + ' m/s²',
                      ),
                      InfoItem(
                        title: 'Y-Axis',
                        value: _accelerometerEvent.y.toStringAsFixed(2) + ' m/s²',
                      ),
                      InfoItem(
                        title: 'Z-Axis',
                        value: _accelerometerEvent.z.toStringAsFixed(2) + ' m/s²',
                      ),
                    ],
                  ),
                ),
              if (_isGyroscopeAvailable)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Gyroscope',
                    icon: Icons.rotate_90_degrees_ccw,
                    children: [
                      InfoItem(
                        title: 'X-Axis',
                        value: _gyroscopeEvent.x.toStringAsFixed(2) + ' rad/s',
                      ),
                      InfoItem(
                        title: 'Y-Axis',
                        value: _gyroscopeEvent.y.toStringAsFixed(2) + ' rad/s',
                      ),
                      InfoItem(
                        title: 'Z-Axis',
                        value: _gyroscopeEvent.z.toStringAsFixed(2) + ' rad/s',
                      ),
                    ],
                  ),
                ),
              if (_isMagnetometerAvailable)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'Magnetometer',
                    icon: Icons.compass_calibration,
                    children: [
                      InfoItem(
                        title: 'X-Axis',
                        value: _magnetometerEvent.x.toStringAsFixed(2) + ' μT',
                      ),
                      InfoItem(
                        title: 'Y-Axis',
                        value: _magnetometerEvent.y.toStringAsFixed(2) + ' μT',
                      ),
                      InfoItem(
                        title: 'Z-Axis',
                        value: _magnetometerEvent.z.toStringAsFixed(2) + ' μT',
                      ),
                    ],
                  ),
                ),
              if (_isUserAccelerometerAvailable)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InfoCard(
                    title: 'User Accelerometer',
                    icon: Icons.directions_run,
                    children: [
                      InfoItem(
                        title: 'X-Axis',
                        value: _userAccelerometerEvent.x.toStringAsFixed(2) + ' m/s²',
                      ),
                      InfoItem(
                        title: 'Y-Axis',
                        value: _userAccelerometerEvent.y.toStringAsFixed(2) + ' m/s²',
                      ),
                      InfoItem(
                        title: 'Z-Axis',
                        value: _userAccelerometerEvent.z.toStringAsFixed(2) + ' m/s²',
                      ),
                      InfoItem(
                        title: 'Note',
                        value: 'User accelerometer excludes gravity, showing only user-induced acceleration.',
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
                              Icons.sensors,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sensor Visualization',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: CustomPaint(
                            painter: SensorPainter(
                              accelerometerX: _accelerometerEvent.x,
                              accelerometerY: _accelerometerEvent.y,
                              gyroscopeX: _gyroscopeEvent.x,
                              gyroscopeY: _gyroscopeEvent.y,
                              theme: Theme.of(context),
                            ),
                            size: const Size(double.infinity, 200),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Tilt your device to see the visualization change',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
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
                  title: 'Other Sensors',
                  icon: Icons.sensors,
                  children: [
                    InfoItem(
                      title: 'Note',
                      value: 'Additional sensors like proximity, light, barometer, etc. require specific permissions and may not be available on all devices.',
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

class SensorPainter extends CustomPainter {
  final double accelerometerX;
  final double accelerometerY;
  final double gyroscopeX;
  final double gyroscopeY;
  final ThemeData theme;

  SensorPainter({
    required this.accelerometerX,
    required this.accelerometerY,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width < size.height ? size.width / 3 : size.height / 3;

    // Draw background grid
    final gridPaint = Paint()
      ..color = theme.colorScheme.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw horizontal and vertical lines
    for (int i = 1; i < 5; i++) {
      final step = size.width / 5;
      canvas.drawLine(
        Offset(i * step, 0),
        Offset(i * step, size.height),
        gridPaint,
      );
    }

    for (int i = 1; i < 3; i++) {
      final step = size.height / 3;
      canvas.drawLine(
        Offset(0, i * step),
        Offset(size.width, i * step),
        gridPaint,
      );
    }

    // Draw center circle
    final centerCirclePaint = Paint()
      ..color = theme.colorScheme.primary.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius, centerCirclePaint);

    // Draw outer circle
    final outerCirclePaint = Paint()
      ..color = theme.colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, outerCirclePaint);

    // Calculate bubble position based on accelerometer data
    // Limit the movement to stay within the circle
    final maxTilt = 10.0; // Maximum tilt in m/s²
    final normalizedX = (accelerometerX / maxTilt).clamp(-1.0, 1.0);
    final normalizedY = (accelerometerY / maxTilt).clamp(-1.0, 1.0);
    
    final bubbleX = centerX + normalizedX * radius * 0.8;
    final bubbleY = centerY + normalizedY * radius * 0.8;

    // Draw bubble
    final bubblePaint = Paint()
      ..color = theme.colorScheme.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(bubbleX, bubbleY), radius * 0.15, bubblePaint);

    // Draw gyroscope indicator (rotation)
    final gyroIndicatorPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Normalize gyroscope values
    final maxGyro = 5.0; // Maximum rotation in rad/s
    final normalizedGyroX = (gyroscopeX / maxGyro).clamp(-1.0, 1.0);
    final normalizedGyroY = (gyroscopeY / maxGyro).clamp(-1.0, 1.0);

    // Draw gyroscope indicator lines
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + normalizedGyroX * radius * 0.7, centerY + normalizedGyroY * radius * 0.7),
      gyroIndicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SensorPainter oldDelegate) {
    return oldDelegate.accelerometerX != accelerometerX ||
           oldDelegate.accelerometerY != accelerometerY ||
           oldDelegate.gyroscopeX != gyroscopeX ||
           oldDelegate.gyroscopeY != gyroscopeY;
  }
}
