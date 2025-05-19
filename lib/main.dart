import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/loginpage.dart';
import 'package:provider/provider.dart';
import 'screens/theme_provider.dart'; // ThemeProvider for managing app themes
import 'screens/themes_screen.dart'; // Optional: screen to manually change theme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Provide theme state to the whole app
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme,     // Light theme definition
      darkTheme: ThemeProvider.darkTheme,  // Dark theme definition
      themeMode: themeProvider.themeMode,  // Apply system/user theme mode
      home: AuthGate(),                    // This is your login/auth wrapper
    );
  }
}
