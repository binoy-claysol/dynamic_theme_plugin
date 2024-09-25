library dynamic_theme_flutter;

// theme_manager.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_theme_plus/json_theme_plus.dart';

class ThemeManager {
  ThemeData? _themeData;

  // Method to initialize the theme by fetching from a URL
  Future<void> initializeTheme(String url) async {
    final themeJson = await _fetchThemeFromUrl(url);
    _themeData = ThemeDecoder.decodeThemeData(((themeJson as List)[0]));
  }

  // Method to get the theme data
  ThemeData? get themeData => _themeData;

  // Internal method to fetch theme data from the provided URL
  Future<Map<String, dynamic>> _fetchThemeFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.first; // Taking the first item as the theme
      } else {
        throw Exception('Failed to load theme data');
      }
    } catch (e) {
      throw Exception('Error fetching theme from URL: $e');
    }
  }
}

// This class allows changing the theme dynamically at runtime
class DynamicThemeManager extends ChangeNotifier {
  ThemeData? _currentTheme;

  DynamicThemeManager(String initialUrl) {
    _fetchAndSetTheme(initialUrl);
  }

  // Getter for the current theme
  ThemeData? get currentTheme => _currentTheme;

  // Method to fetch theme from a new URL and update it
  Future<void> changeTheme(String url) async {
    try {
      final themeJson = await _fetchThemeFromUrl(url);
      _currentTheme = ThemeDecoder.decodeThemeData(themeJson);
      notifyListeners(); // Notify listeners to update the theme
    } catch (e) {
      throw Exception('Error changing theme: $e');
    }
  }

  // Internal method to fetch theme JSON from the provided URL
  Future<Map<String, dynamic>> _fetchThemeFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.first; // Taking the first item as the theme
      } else {
        throw Exception('Failed to load theme data');
      }
    } catch (e) {
      throw Exception('Error fetching theme from URL: $e');
    }
  }

  // Private method to initialize the theme
  Future<void> _fetchAndSetTheme(String url) async {
    await changeTheme(url);
  }
}
