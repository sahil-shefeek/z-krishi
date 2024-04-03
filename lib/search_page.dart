import 'package:flutter/material.dart';

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
  List<CommunityPost> communityPosts = [
    CommunityPost(
      username: 'User1',
      profilePictureUrl: 'profile1.jpg',
      caption: 'First post caption',
    ),
    CommunityPost(
      username: 'User2',
      profilePictureUrl: 'profile2.jpg',
      caption: 'Second post caption',
    ),
    // Add more posts as needed
  ];

  bool isLoading = false;

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
        backgroundImage: AssetImage(post.profilePictureUrl),
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
