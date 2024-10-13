import 'package:flutter/material.dart';
import 'package:example/src/core/model/omdb_response.dart';

class SelectedItems extends StatefulWidget {
  final List<Movie> selectedMovies;
  final Function(List<Movie>) onMoviesUpdated;

  SelectedItems({super.key, required this.selectedMovies, required this.onMoviesUpdated});

  @override
  _SelectedItemsState createState() => _SelectedItemsState();
}

class _SelectedItemsState extends State<SelectedItems> {
  late List<Movie> _selectedMovies;

  @override
  void initState() {
    super.initState();
    _selectedMovies = List.from(widget.selectedMovies);
  }

  void _removeMovie(int index) {
    setState(() {
      _selectedMovies.removeAt(index);
    });
    widget.onMoviesUpdated(_selectedMovies);
    if (_selectedMovies.isEmpty) {
      Navigator.of(context).pop(_selectedMovies);
    }
  }

  // Method to handle reordering
  void _reorderMovies(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final movie = _selectedMovies.removeAt(oldIndex);
      _selectedMovies.insert(newIndex, movie);
    });
    widget.onMoviesUpdated(_selectedMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Movies'),
      ),
      body: _selectedMovies.isEmpty
          ? const Center(child: Text('No movies selected.'))
          : ReorderableListView.builder(
        itemCount: _selectedMovies.length,
        onReorder: _reorderMovies,
        itemBuilder: (context, index) {
          final movie = _selectedMovies[index];
          return ListTile(
            key: ValueKey(movie),
            title: Text(movie.title),
            subtitle: Text('${movie.year} (${movie.type})'),
            leading: movie.poster != 'N/A'
                ? Image.network(movie.poster, width: 50, fit: BoxFit.cover)
                : const Icon(Icons.movie),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => _removeMovie(index),
            ),
          );
        },
      ),
    );
  }
}
