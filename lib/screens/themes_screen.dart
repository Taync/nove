import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import ThemeProvider

class ThemesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to know the current theme and toggle the theme
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Themes'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Toggle the theme when the button is pressed
            themeProvider.toggleTheme(!isDark);
          },
          child: Text(isDark ? "Switch to Light Mode" : "Switch to Dark Mode"),
        ),
      ),
    );
  }
}
