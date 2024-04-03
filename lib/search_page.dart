import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommunityPost {
  final String username;
  final String profilePictureUrl;
  final String caption;

  CommunityPost({
    required this.username,
    required this.profilePictureUrl,
    required this.caption,
  });
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Mock list of community posts
  List<CommunityPost> communityPosts = [];
  bool isLoading = false;
  int currentPage = 1; // Keep track of the current page

  ScrollController _scrollController = ScrollController();

  // Function to fetch posts from API
  Future<void> fetchPosts() async {
    final String apiUrl =
        'http://localhost:8000/api/posts/'; // Change the URL to your actual API endpoint

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Successful API call
        final List<dynamic> responseData = json.decode(response.body);
        List<CommunityPost> newPosts = responseData.map((post) {
          return CommunityPost(
            username: post['username'],
            profilePictureUrl: post['profile_picture_url'],
            caption: post['caption'],
          );
        }).toList();

        setState(() {
          isLoading = false;
          communityPosts.addAll(newPosts); // Add fetched posts to the list
        });
      } else {
        // Handle errors, for example, show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load posts. Please try again later.'),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle exceptions, for example, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle scrolling and load more posts if needed
  void _loadMorePosts() {
    if (!isLoading) {
      setState(() {
        currentPage++; // Increment page number for the next API call
      });
      fetchPosts();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Initial fetch when the page is loaded

    // Attach listener to scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has reached the end of the list
        _loadMorePosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach scroll controller
              itemCount: communityPosts.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == communityPosts.length) {
                  return _buildProgressIndicator();
                } else {
                  return _buildPostItem(communityPosts[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(CommunityPost post) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(post.profilePictureUrl),
      ),
      title: Text(post.username),
      subtitle: Text(post.caption),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () {
              // Handle like functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              // Handle comment functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Handle share functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
