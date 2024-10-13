import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../commoms/default_row.dart';
import '../controllers/controller.dart';
import 'package:example/src/module/charters_models/episode.dart';

class SeasonsPage extends StatefulWidget {
  final DynamicThemeManager themeManager;
  const SeasonsPage({super.key, required this.themeManager});

  @override
  State<SeasonsPage> createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  final _controller = FinalSpaceController();
  final TextEditingController _searchController = TextEditingController();
  List<EpisodeModel> displayedItems = [];
  final Set<int> _favoriteEpisodes = {}; // Set to store favorite episodes

  int epIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      displayedItems = _controller.episodes
          .where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes'),
        centerTitle: true,
        backgroundColor: widget.themeManager.currentTheme!.primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Observer(
            builder: (context) {
              return AnimatedBuilder(
                builder: (content, _) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      FutureBuilder<List<EpisodeModel>>(
                        future: _controller.getEpisode(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _controller.episodes = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _searchController.text.isEmpty
                                  ? _controller.episodes.length
                                  : displayedItems.length,
                              itemBuilder: (context, index) {
                                final episodes = _searchController.text.isEmpty
                                    ? _controller.episodes[index]
                                    : displayedItems[index];
                                final isFavorited = _favoriteEpisodes.contains(index);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller.selectedIndex = index;
                                    });
                                    dialog();
                                  },
                                  child: Container(
                                    height: 200,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Episode Image
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.secondaryContainer,
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                episodes.imgUrl ??
                                                    "https://finalspaceapi.com/api/character/avatar/time_swap_sammy.jpg",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Episode Title with Favorite Icon
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  episodes.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isFavorited
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isFavorited ? Colors.red : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (isFavorited) {
                                                      _favoriteEpisodes.remove(index);
                                                    } else {
                                                      _favoriteEpisodes.add(index);
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
                  );
                },
                animation: widget.themeManager,
              );
            }
        ),
      ),
    );
  }

  Future dialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if ((_searchController.text.isEmpty && _controller.episodes.isEmpty) ||
            (_searchController.text.isNotEmpty && displayedItems.isEmpty) ||
            _controller.selectedIndex >= (_searchController.text.isEmpty
                ? _controller.episodes.length
                : displayedItems.length)) {
          return AlertDialog(
            content: Text("No episode data available."),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }

        var episode = _searchController.text.isEmpty
            ? _controller.episodes[_controller.selectedIndex]
            : displayedItems[_controller.selectedIndex];
        return AlertDialog(
          title: Center(
            child: Text(
              episode.name!,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: 600,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    image: DecorationImage(
                      image: NetworkImage(episode.imgUrl ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                DefaultRow(
                  name: episode.name ?? "NULL",
                  label: 'Name : ',
                  fontSize: 14,
                  fontSize2: 16,
                ),
                SizedBox(height: 6),
                DefaultRow(
                  name: episode.director ?? "NULL",
                  label: 'Director : ',
                  fontSize: 14,
                  fontSize2: 14,
                ),
                SizedBox(height: 6),
                DefaultRow(
                  name: episode.writer ?? "NULL",
                  label: 'Writer : ',
                  fontSize: 14,
                  fontSize2: 14,
                ),
                SizedBox(height: 6),
                DefaultRow(
                  name: episode.airDate ?? "NULL",
                  label: 'Release Date : ',
                  fontSize: 14,
                  fontSize2: 14,
                ),
                SizedBox(height: 6),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
