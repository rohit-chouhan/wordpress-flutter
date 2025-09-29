part of 'wordpress_base.dart';

class MediaModule {
  final WordPress wp;

  MediaModule(this.wp);

  /// Retrieves a list of media items.
  ///
  /// Returns a list of [Media] objects.
  Future<List<Media>> list() async {
    final response = await wp.get('media');
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Media.fromJson(json)).toList();
  }

  /// Uploads a media file to WordPress.
  ///
  /// [file] - The file to upload (should have a path property).
  /// [title] - Optional title for the media.
  /// [description] - Optional description for the media.
  ///
  /// Returns the uploaded [Media] object.
  Future<Media> upload(
    dynamic file, {
    String? title,
    String? description,
  }) async {
    final url = Uri.parse('${wp.apiBase}/media');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(wp.getAuthHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    if (title != null) request.fields['title'] = title;
    if (description != null) request.fields['description'] = description;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Media.fromJson(data);
    } else {
      throw WordPressException(
        'Upload failed',
        statusCode: response.statusCode,
        data: response.body,
      );
    }
  }
}
