// main.dart

import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'movie_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create an instance of DynamicThemeManager with the initial URL
  await _initializeFirebase();
  final dynamicThemeManager = DynamicThemeManager('Sharanya');

  runApp(MyApp(dynamicThemeManager: dynamicThemeManager));
}

Future<void> _initializeFirebase() async {
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } else {
      print('Firebase is already initialized.');
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}


class MyApp extends StatelessWidget {
  final DynamicThemeManager dynamicThemeManager;

  const MyApp({Key? key, required this.dynamicThemeManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: dynamicThemeManager,
      builder: (context, _) {
        return MaterialApp(
          title: 'Dynamic Theme Example',
          theme: dynamicThemeManager.currentTheme ?? ThemeData.light(),
          home: MovieListScreen(themeManager: dynamicThemeManager),
        );
      },
    );
  }
}