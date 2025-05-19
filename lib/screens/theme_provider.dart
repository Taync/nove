import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  //custom light theme
  static final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF), // pure white
    foregroundColor: Color.fromRGBO(0, 50, 97, 1), // custom text color
    elevation: 0,
  ),
 );
  //custom dark theme
   static final darkTheme = ThemeData(
   brightness: Brightness.dark,
   primarySwatch: Colors.blue,
   scaffoldBackgroundColor: Color(0xFF000000),
   cardColor: Color(0xFF1E1E1E),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF121212), // deep dark
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
