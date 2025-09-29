part of 'wordpress_base.dart';

class Comments {
  final WordPress wp;

  Comments(this.wp);

  /// Retrieves a list of comments for a specific post.
  ///
  /// [postId] - The post ID to get comments for.
  /// Returns a list of [Comment] objects.
  Future<List<Comment>> list(int postId) async {
    final response = await wp.get('comments?post=$postId');
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Comment.fromJson(json)).toList();
  }

  /// Adds a new comment to a post.
  ///
  /// [postId] - The post ID to add the comment to.
  /// [content] - The comment content.
  /// [parentId] - Parent comment ID for replies.
  /// [authorName] - Author name (for unauthenticated users).
  /// [authorEmail] - Author email (for unauthenticated users).
  ///
  /// Returns the created [Comment] object.
  Future<Comment> add(
    int postId,
    String content, {
    int? parentId,
    String? authorName,
    String? authorEmail,
  }) async {
    final headers = wp.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final body = {
      'post': postId,
      'content': content,
      if (parentId != null) 'parent': parentId,
      if (authorName != null) 'author_name': authorName,
      if (authorEmail != null) 'author_email': authorEmail,
    };

    final response = await wp.post(
      'comments',
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    return Comment.fromJson(data);
  }
}
