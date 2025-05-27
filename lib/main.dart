import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _isSystemTheme = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSystemTheme = prefs.getBool('isSystemTheme') ?? true;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isLoading = false;
    });
  }

  ThemeData _buildThemeData(ColorScheme colorScheme, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Outfit',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'NoyhR'),
        displayMedium: TextStyle(fontFamily: 'NoyhR'),
        displaySmall: TextStyle(fontFamily: 'NoyhR'),
        headlineLarge: TextStyle(fontFamily: 'NoyhR'),
        headlineMedium: TextStyle(fontFamily: 'NoyhR'),
        headlineSmall: TextStyle(fontFamily: 'NoyhR'),
        titleLarge: TextStyle(fontFamily: 'NoyhR'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // Use dynamic color scheme if available (Android 12+)
          lightColorScheme = lightDynamic;
          darkColorScheme = darkDynamic;
        } else {
          // Fallback color schemes
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: 'Device Info',
          theme: _buildThemeData(lightColorScheme, Brightness.light),
          darkTheme: _buildThemeData(darkColorScheme, Brightness.dark),
          themeMode: _isSystemTheme
              ? ThemeMode.system
              : _isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}