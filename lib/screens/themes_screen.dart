import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentMode = themeProvider.themeMode;

    bool isDarkMode = currentMode == ThemeMode.dark;
    bool isSystem = currentMode == ThemeMode.system;

    return Scaffold(
      appBar: AppBar(title: Text('Themes')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dark Mode", style: TextStyle(fontSize: 18)),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value); // true = dark, false = light
              },
            ),
            SizedBox(height: 24),
            Text("System Theme", style: TextStyle(fontSize: 18)),
            Switch(
              value: isSystem,
              onChanged: (value) {
                if (value) {
                  themeProvider.setThemeMode(ThemeMode.system);
                } else {
                  themeProvider.setThemeMode(
                    ThemeMode.light,
                  ); // Default fallback
                }
              },
            ),
            SizedBox(height: 40),
            Text(
              'Current Mode: ${_getReadableTheme(currentMode)}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
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
