library wordpress_base;

/// The main WordPress SDK class that provides access to all WordPress REST API endpoints.
///
/// This class initializes all the modules for interacting with different WordPress resources
/// such as posts, pages, users, categories, tags, comments, and media.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'exception.dart';

part 'auth.dart';
part 'posts.dart';
part 'pages.dart';
part 'categories.dart';
part 'tags.dart';
part 'comments.dart';
part 'media.dart';
part 'users.dart';

class WordPress {
  final String baseUrl;
  final http.Client _client;
  String? _token;

  late final Auth auth;
  late final Posts posts;
  late final Pages pages;
  late final Categories categories;
  late final Tags tags;
  late final Comments comments;
  late final MediaModule media;
  late final Users users;

  /// Creates a new WordPress instance.
  ///
  /// [baseUrl] is the base URL of the WordPress site (e.g., 'https://example.com').
  /// [client] is an optional HTTP client to use for requests.
  WordPress({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client() {
    auth = Auth(this);
    posts = Posts(this);
    pages = Pages(this);
    categories = Categories(this);
    tags = Tags(this);
    comments = Comments(this);
    media = MediaModule(this);
    users = Users(this);
  }

  /// Gets the base API URL for WordPress REST API v2.
  String get apiBase => '$baseUrl/wp-json/wp/v2';

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$apiBase/$endpoint');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw WordPressException('GET $endpoint failed',
          statusCode: response.statusCode, data: response.body);
    }
    return response;
  }

  Future<http.Response> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$apiBase/$endpoint');
    final response = await _client.post(url, headers: headers, body: body);
    if (response.statusCode >= 400) {
      throw WordPressException('POST $endpoint failed',
          statusCode: response.statusCode, data: response.body);
    }
    return response;
  }

  Future<http.Response> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$apiBase/$endpoint');
    final response = await _client.put(url, headers: headers, body: body);
    if (response.statusCode >= 400) {
      throw WordPressException('PUT $endpoint failed',
          statusCode: response.statusCode, data: response.body);
    }
    return response;
  }

  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$apiBase/$endpoint');
    final response = await _client.delete(url, headers: headers);
    if (response.statusCode >= 400) {
      throw WordPressException('DELETE $endpoint failed',
          statusCode: response.statusCode, data: response.body);
    }
    return response;
  }

  String? getToken() {
    return _token;
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, String> getAuthHeaders() {
    final token = getToken();
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }
}
