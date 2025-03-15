import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> posts = [
      'Post 1: This is the first post.',
      'Post 2: This is the second post.',
      'Post 3: This is the third post.',
      'Post 4: This is the fourth post.',
      'Post 5: This is the fifth post.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index]),
          );
        },
      ),
    );
  }
}
