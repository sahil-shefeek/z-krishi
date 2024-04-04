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

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
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
    // Placeholder image URL for the user icon
    final String placeholderImageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReF9MbJyxKxJrvWKlm95sFTyoshI4-TLBKp3oOqho7MQ&s';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          Container(
            height: 200, // Adjust the height as needed
            width: double.infinity,
            child: Image.network(
              post.profilePictureUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          // User icon with a placeholder
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      post.profilePictureUrl.isNotEmpty
                          ? post.profilePictureUrl
                          : placeholderImageUrl),
                ),
                SizedBox(width: 8),
                Text(post.username,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Post caption
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.caption),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
