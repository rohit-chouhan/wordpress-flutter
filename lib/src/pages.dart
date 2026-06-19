part of 'wordpress_base.dart';

class Pages {
  final WordPress wp;

  Pages(this.wp);

  /// Retrieves a list of pages with optional filtering.
  ///
  /// [perPage] - Number of pages per page.
  /// [page] - Page number for pagination.
  /// [search] - Search query string.
  ///
  /// Returns a list of [Page] objects.
  Future<List<Page>> list({int? perPage, int? page, String? search}) async {
    final queryParams = <String, String>{};
    if (perPage != null) queryParams['per_page'] = perPage.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (search != null) queryParams['search'] = search;

    final endpoint =
        'pages${queryParams.isNotEmpty ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}' : ''}';
    final response = await wp.get(endpoint);
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Page.fromJson(json)).toList();
  }

  /// Fetches a single page by its ID.
  ///
  /// [id] - The page ID.
  /// Returns a [Page] object.
  Future<Page> fetchById(int id) async {
    final response = await wp.get('pages/$id');
    final data = jsonDecode(response.body);
    return Page.fromJson(data);
  }
}
