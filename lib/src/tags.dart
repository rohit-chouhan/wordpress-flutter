part of 'wordpress_base.dart';

class Tags {
  final WordPress wp;

  Tags(this.wp);

  /// Retrieves a list of all tags.
  ///
  /// Returns a list of [Tag] objects.
  Future<List<Tag>> list() async {
    final response = await wp.get('tags');
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Tag.fromJson(json)).toList();
  }
}
