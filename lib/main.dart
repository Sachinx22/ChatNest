import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';

// Global theme controller
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load saved dark mode setting
  final prefs = await SharedPreferences.getInstance();

  darkModeNotifier.value =
      prefs.getBool('darkModeEnabled') ?? false;

  runApp(const ChatNestApp());
}

class ChatNestApp extends StatelessWidget {
  const ChatNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChatNest',

          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.dark,
          ),

          themeMode: isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const SplashScreen(),
        );
      },
    );
  }
}