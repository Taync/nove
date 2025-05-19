import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import ThemeProvider

class ThemesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentMode = themeProvider.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Themes'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(true); // Switch to dark
              },
              child: const Text("Switch to Dark Mode"),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(false); // Switch to light
              },
              child: const Text("Switch to Light Mode"),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                themeProvider.setThemeMode(ThemeMode.system); // Use system theme
              },
              child: const Text("Match System Theme"),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Current Mode: ${_getReadableTheme(currentMode)}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _getReadableTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Light Mode";
      case ThemeMode.dark:
        return "Dark Mode";
      case ThemeMode.system:
        return "System Default";
    }
  }
}
