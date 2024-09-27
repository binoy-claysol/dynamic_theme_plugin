library dynamic_theme_flutter;

// theme_manager.dart

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_theme_plus/json_theme_plus.dart';

class ThemeManager {
  ThemeData? _themeData;

  // Method to initialize the theme by fetching from Firestore
  Future<void> initializeTheme(String documentId) async {
    _themeData = await _fetchThemeFromFirestore(documentId);
  }

  // Method to get the theme data
  ThemeData? get themeData => _themeData;

  // Internal method to fetch theme data from Firestore
  Future<ThemeData?> _fetchThemeFromFirestore(String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('themes')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return ThemeDecoder.decodeThemeData(data);
      } else {
        throw Exception('Theme data not found in Firestore');
      }
    } catch (e) {
      throw Exception('Error fetching theme from Firestore: $e');
    }
  }
}

// This class allows changing the theme dynamically at runtime and listening for real-time updates
class DynamicThemeManager extends ChangeNotifier {
  ThemeData? _currentTheme;
  final String documentId;

  // Constructor initializes the theme and sets up a Firestore listener
  DynamicThemeManager(this.documentId) {
    _initializeThemeWithListener(documentId);
  }

  // Getter for the current theme
  ThemeData? get currentTheme => _currentTheme;

  // Initialize the theme and set up a real-time listener for updates from Firestore
  Future<void> _initializeThemeWithListener(String documentId) async {
    // Fetch the initial theme
    await _fetchAndSetTheme(documentId);

    // Set up Firestore listener for real-time updates
    FirebaseFirestore.instance
        .collection('themes')
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _currentTheme = ThemeDecoder.decodeThemeData(data);
        notifyListeners(); // Notify listeners to update the theme
      } else {
        print('No theme data found for real-time updates.');
      }
    });
  }

  // Method to manually fetch theme from Firestore and update it
  Future<void> _fetchAndSetTheme(String documentId) async {
    try {
      _currentTheme = await _fetchThemeFromFirestore(documentId);
      notifyListeners(); // Notify listeners to update the theme
    } catch (e) {
      print('Error changing theme: $e');
    }
  }

  // Internal method to fetch theme JSON from Firestore
  Future<ThemeData?> _fetchThemeFromFirestore(String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('themes')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return ThemeDecoder.decodeThemeData(data);
      } else {
        throw Exception('Theme data not found in Firestore');
      }
    } catch (e) {
      throw Exception('Error fetching theme from Firestore: $e');
    }
  }
}