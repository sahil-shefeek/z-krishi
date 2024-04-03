import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _search() {
    setState(() {
      _searchQuery = _searchController.text;
      // You can implement your search functionality here
      // For now, let's just print the search query
      print('Searching for: $_searchQuery');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Find a user',
                  labelText: 'Enter Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded edges
                  ),
                ),
                onChanged: (value) {
                  // You can perform live search as the user types if needed
                },
              ),
            ),
            SizedBox(width: 10), // Add space between search bar and icon button
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _search,
              iconSize: 30,
              color: Theme.of(context)
                  .primaryColor, // Use the primary color of your theme
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SearchPage(),
  ));
}
