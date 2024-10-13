import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:example/src/core/constants/movie_service.dart';
import 'package:example/src/core/model/omdb_response.dart';
import 'package:example/src/ui/cast_page.dart';
import 'package:example/src/ui/episode_page.dart';
import 'package:example/src/ui/liquid_refresh/news_list.dart';
import 'package:flutter/material.dart';
import 'package:example/src/selected_items.dart';

class MovieListScreen extends StatefulWidget {
  final DynamicThemeManager themeManager;

  const MovieListScreen({Key? key, required this.themeManager}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _movies;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = 'Marvel';
  List<Movie> selectedMovies = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    setState(() {
      _movies = MovieService().fetchMovies(_searchQuery);
    });
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectedItems(
              selectedMovies: selectedMovies,
              onMoviesUpdated: (updatedMovies) {
                setState(() {
                  selectedMovies = updatedMovies;
                });
              },
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CastPage(themeManager: widget.themeManager)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SeasonsPage(themeManager: widget.themeManager)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(themeManager: widget.themeManager)),
        );
        break;
    }
  }

  Widget buildMovieListPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
                  final movies = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return AnimatedBuilder(
                        animation: widget.themeManager,
                        builder: (BuildContext context, Widget? child) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 5),
                            ),
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: Theme.of(context).colorScheme.tertiary,
                                title: Text(movie.title, textAlign: TextAlign.center),
                                subtitle: Text('${movie.year} (${movie.type})'),
                              ),
                              child: movie.poster != 'N/A'
                                  ? Stack(
                                children: [
                                  Image.network(
                                    movie.poster,
                                    fit: BoxFit.cover,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedMovies.contains(movies[index])) {
                                          selectedMovies.remove(movies[index]);
                                        } else {
                                          selectedMovies.add(movies[index]);
                                        }
                                      });
                                      print(selectedMovies);
                                    },
                                    child: Icon(
                                      Icons.star,
                                      color: selectedMovies.contains(movies[index])
                                          ? Colors.blue
                                          : Colors.white,
                                      size: 34,
                                    ),
                                  ),
                                ],
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
    );
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
          body: buildMovieListPage(),

          // BottomNavigationBar
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onNavBarTap,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.movie),
                label: 'Movies',
                backgroundColor: widget.themeManager.currentTheme?.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.favorite),
                   selectedMovies.length == 0 ? SizedBox.shrink() :
                   Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(4),
                      child:Text(selectedMovies.length.toString(),style:TextStyle(color: Colors.white,fontSize: 8))
                    )
                  ],
                ),
                label: 'Favorites',
                backgroundColor: widget.themeManager.currentTheme?.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.auto_stories_sharp),
                label: 'Characters',
                backgroundColor: widget.themeManager.currentTheme?.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.movie_edit),
                label: 'Episodes',
                backgroundColor: widget.themeManager.currentTheme?.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list),
                label: 'list',
                backgroundColor: widget.themeManager.currentTheme?.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}






