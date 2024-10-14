import 'dart:async';
import 'dart:math';
import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:example/src/controllers/controller.dart';
import 'liquid.pull.refresh.dart';
import 'news.web.view.dart';

class MyHomePage extends StatefulWidget {
  final DynamicThemeManager themeManager;
  const MyHomePage({super.key, required this.themeManager});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10;
  Stream<int> counterStream =
  Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);

  ScrollController? _scrollController;

  final _controller = FinalSpaceController();
  String searchQuery = '';
  List<String> _headings = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14',
  ];
  List<String> _descriptions = [
    'Description for 1',
    'Description for 2',
    'Description for 3',
    'Description for 4',
    'Description for 5',
    'Description for 6',
    'Description for 7',
    'Description for 8',
    'Description for 9',
    'Description for 10',
    'Description for 11',
    'Description for 12',
    'Description for 13',
    'Description for 14',
  ];
  List<String> _filteredHeadings = [];
  List<String> _filteredDescriptions = [];

  final TextEditingController _searchController = TextEditingController(); // Controller for the search field

  bool _isDarkMode = false; // Boolean to track dark mode state

  @override
  void initState() {
    super.initState();
    _controller.getNews("india");
    _scrollController = ScrollController();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        refreshNum = Random().nextInt(100); // Update refreshNum with a random number
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Refresh complete'),
        action: SnackBarAction(
          label: 'RETRY',
          onPressed: () {
            _refreshIndicatorKey.currentState?.show();
          },
        ),
      ),
    );
  }

  void _filterItems() {
    setState(() {
      searchQuery = _searchController.text; // Get the text from the controller
      _filteredHeadings = _headings
          .where((heading) => heading.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      // Filter descriptions based on filtered headings
      _filteredDescriptions = _filteredHeadings
          .map((heading) => _descriptions[_headings.indexOf(heading)])
          .toList();
    });
  }

  void _deleteItem(int index) {
    _controller.newsList.removeAt(index); // Delete the item
    ScaffoldMessenger.of(context).showSnackBar( // Show a snackbar message
      const SnackBar(
        content: Text('Deleted successfully'),
      ),
    );
  }

  // Method to add a new item
  void _addItem(String heading, String description) {
    setState(() {
      _headings.add(heading);
      _descriptions.add(description);
      _filteredHeadings.add(heading);
      _filteredDescriptions.add(description);
    });
  }

  // Show dialog to add item
  void _showAddItemDialog() {
    String heading = '';
    String description = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  heading = value; // Capture heading input
                },
                decoration: const InputDecoration(hintText: 'Heading'),
              ),
              const SizedBox(height: 10), // Space between fields
              TextField(
                onChanged: (value) {
                  description = value; // Capture description input
                },
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (heading.isNotEmpty && description.isNotEmpty) {
                  _addItem(heading, description); // Pass heading and description
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightGreen, // Light green color for Submit
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent, // Light red color for Cancel
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("News List"),
        backgroundColor: widget.themeManager.currentTheme!.primaryColor, // Change the background color here
        actions: [
          // Toggle button for theme switching
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            activeColor: Colors.white,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        color: widget.themeManager.currentTheme!.primaryColor,
        onRefresh: () async {
          _controller.getNews("india");
        },
        child: Observer(
          builder: (context) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container(
                color: _isDarkMode ? Colors.black : Colors.white, // Background color based on theme
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController, // Assign the controller
                              decoration: InputDecoration(
                                hintText: 'Type to search...',
                                border: const OutlineInputBorder(),
                                hintStyle: TextStyle(
                                  color: _isDarkMode ? Colors.white54 : Colors.black54, // Hint text color
                                ),
                              ),
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black, // Text color
                              ),
                              onChanged: (value) {
                                _filterItems(); // Call filter method when text changes
                              },
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                color: Colors.pink, // Set the background color to pink
                                shape: BoxShape.circle, // Make the container circular
                              ),
                              padding: const EdgeInsets.all(8.0), // Add some padding for better appearance
                              child: const Icon(
                                Icons.search,
                                color: Colors.white, // Set icon color to white for contrast
                              ),
                            ),
                            onPressed: () {
                              _controller.getNews(_searchController.text);
                              _searchController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Observer(
                        builder: (context) {
                          return ListView.builder(
                            padding: kMaterialListPadding,
                            itemCount: _controller.newsList.length,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              var newsItems = _controller.newsList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewsWebView(link: newsItems.url),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode
                                        ? Colors.grey[850]
                                        : Colors.red[50], // Background color based on theme
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ListTile(
                                    isThreeLine: true,
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.lightBlue[300], // Background color
                                      ),
                                      child: Text(
                                        '${index + 1}', // Display the index + 1
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      newsItems.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode ? Colors.white : Colors.black, // Text color
                                      ),
                                    ),
                                    subtitle: Text(
                                      newsItems.description,
                                      style: TextStyle(
                                        color: _isDarkMode ? Colors.white70 : Colors.black54, // Subtitle color
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: _isDarkMode ? Colors.red : Colors.red, // Delete icon color changes to red in both themes
                                      ),
                                      onPressed: () => _deleteItem(index), // Call delete method
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
