part of 'wordpress_base.dart';

class Posts {
  final WordPress wp;

  Posts(this.wp);

  /// Retrieves a list of posts with optional filtering.
  ///
  /// [perPage] - Number of posts per page (default: WordPress default).
  /// [page] - Page number for pagination.
  /// [search] - Search query string.
  /// [category] - Category ID to filter by.
  /// [tag] - Tag ID to filter by.
  ///
  /// Returns a list of [Post] objects.
  Future<List<Post>> list({
    int? perPage,
    int? page,
    String? search,
    int? category,
    int? tag,
  }) async {
    final queryParams = <String, String>{};
    if (perPage != null) queryParams['per_page'] = perPage.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (search != null) queryParams['search'] = search;
    if (category != null) queryParams['categories'] = category.toString();
    if (tag != null) queryParams['tags'] = tag.toString();

    final endpoint =
        'posts${queryParams.isNotEmpty ? '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&') : ''}';
    final response = await wp.get(endpoint);
    final data = jsonDecode(response.body);
    if (data is List) {
      return data
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      // If not a list, return empty (could be error or single item)
      return [];
    }
  }

  /// Fetches a single post by its ID.
  ///
  /// [id] - The post ID.
  /// Returns a [Post] object.
  Future<Post> fetchById(int id) async {
    final response = await wp.get('posts/$id');
    final data = jsonDecode(response.body);
    return Post.fromJson(data);
  }

  /// Fetches a single post by its slug.
  ///
  /// [slug] - The post slug.
  /// Returns a [Post] object.
  Future<Post> fetchBySlug(String slug) async {
    final response = await wp.get('posts?slug=$slug');
    final data = jsonDecode(response.body) as List;
    if (data.isEmpty) {
      throw WordPressException('Post not found');
    }
    return Post.fromJson(data.first);
  }
}
