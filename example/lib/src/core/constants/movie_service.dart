import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/omdb_response.dart';

// Movie model class (defined earlier)

class MovieService {
  // Fetch data from the OMDB API
  Future<List<Movie>> fetchMovies(String searchTerm) async {
    final url = Uri.parse(
        'http://www.omdbapi.com//?s=$searchTerm&page=2&apikey=65d99f31');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['Response'] == 'True') {
          List<dynamic> searchResults = jsonResponse['Search'];
          return searchResults.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load movies');
        }
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching movies: $e');
    }
  }
}