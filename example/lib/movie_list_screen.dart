import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:example/src/core/constants/movie_service.dart';
import 'package:example/src/core/model/omdb_response.dart';
import 'package:flutter/material.dart';

class MovieListScreen extends StatefulWidget {
  final DynamicThemeManager themeManager;

  const MovieListScreen({Key? key, required this.themeManager})
      : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _movies;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = 'Marvel'; // Default search query

  @override
  void initState() {
    super.initState();
    _fetchMovies(); // Fetch movies with default search term
  }

  // Method to fetch movies based on the current search query
  void _fetchMovies() {
    setState(() {
      _movies = MovieService().fetchMovies(_searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.themeManager,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search Marvel Movies'),
            backgroundColor: widget.themeManager.currentTheme?.primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search box
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Movies',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = _searchController.text;
                        });
                        _fetchMovies();
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Movie>>(
                    future: _movies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No movies found'));
                      } else {
                        // Build the grid of movies
                        final movies = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing: 10.0, // Space between columns
                            mainAxisSpacing: 10.0, // Space between rows
                            childAspectRatio:
                                0.7, // Aspect ratio for movie item (poster + title)
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return AnimatedBuilder(
                              animation: widget.themeManager,
                              builder: (BuildContext context, Widget? child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 5)
                                  ),
                                  child: GridTile(
                                    footer: GridTileBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.tertiary,
                                      // Use tertiary color from the theme
                                      title: Text(movie.title,
                                          textAlign: TextAlign.center),
                                      subtitle:
                                          Text('${movie.year} (${movie.type})'),
                                    ),
                                    child: movie.poster != 'N/A'
                                        ? Image.network(
                                            movie.poster,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.movie, size: 50),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
