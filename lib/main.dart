import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/loginpage.dart';
import 'package:provider/provider.dart';
import 'screens/theme_provider.dart'; // Import ThemeProvider
import 'screens/themes_screen.dart'; // Import the ThemesScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to set the current theme
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.themeMode, // Use the current theme mode
      home: AuthGate(), // Navigate to ThemesScreen
    );
  }
}
