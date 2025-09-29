part of 'wordpress_base.dart';

class Categories {
  final WordPress wp;

  Categories(this.wp);

  /// Retrieves a list of all categories.
  ///
  /// Returns a list of [Category] objects.
  Future<List<Category>> list() async {
    final response = await wp.get('categories');
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Category.fromJson(json)).toList();
  }
}
