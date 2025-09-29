import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';

class PostsScreen extends StatefulWidget {
  final WordPress wp;

  const PostsScreen({super.key, required this.wp});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts({bool loadMore = false}) async {
    if (_isLoading || (!loadMore && _posts.isNotEmpty)) return;

    setState(() {
      _isLoading = true;
      if (!loadMore) {
        _error = null;
        _currentPage = 1;
      }
    });

    try {
      final posts = await widget.wp.posts.list(
        perPage: 10,
        page: loadMore ? _currentPage : 1,
      );

      setState(() {
        if (loadMore) {
          _posts.addAll(posts);
          _currentPage++;
        } else {
          _posts = posts;
        }
        _hasMore = posts.length == 10;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : () => _fetchPosts(),
                child: const Text('Refresh Posts'),
              ),
              const SizedBox(width: 16),
              if (_hasMore && _posts.isNotEmpty)
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _fetchPosts(loadMore: true),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Load More'),
                ),
            ],
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: _posts.isEmpty && !_isLoading
              ? const Center(child: Text('No posts loaded'))
              : ListView.builder(
                  itemCount:
                      _posts.length + (_isLoading && _posts.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _posts.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final post = _posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          post.title?['rendered'] ?? 'No title',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${post.id} • Author: ${post.author}'),
                            Text('Date: ${post.date}'),
                            Text(
                              post.excerpt?['rendered']?.replaceAll(
                                    RegExp(r'<[^>]*>'),
                                    '',
                                  ) ??
                                  'No excerpt',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => _navigateToPostDetail(post),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title?['rendered'] ?? 'Post Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title?['rendered'] ?? 'No title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('ID: ${post.id}'),
            Text('Author: ${post.author}'),
            Text('Date: ${post.date}'),
            Text('Status: ${post.status}'),
            const SizedBox(height: 16),
            if (post.content?['rendered'] != null) ...[
              const Text(
                'Content:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                post.content!['rendered']!.replaceAll(RegExp(r'<[^>]*>'), ''),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Full Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  post.getFullResponse().toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
