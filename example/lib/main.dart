// main.dart

import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of DynamicThemeManager with the initial URL
  final dynamicThemeManager = DynamicThemeManager('https://66f1209841537919154fa383.mockapi.io/api/v1/getThemeJson');

  runApp(MyApp(dynamicThemeManager: dynamicThemeManager));
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
          home: MyHomePage(dynamicThemeManager: dynamicThemeManager),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final DynamicThemeManager dynamicThemeManager;

  const MyHomePage({Key? key, required this.dynamicThemeManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Theme Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press the button to change the theme dynamically!',
            ),
            ElevatedButton(
              onPressed: () async {
                // Change theme by providing a new URL
                await dynamicThemeManager.changeTheme('https://66f1209841537919154fa383.mockapi.io/api/v1/getAnotherTheme');
              },
              child: const Text('Change Theme'),
            ),
          ],
        ),
      ),
    );
  }
}