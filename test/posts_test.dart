import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Posts Tests', () {
    test('list returns list of Posts', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/posts');
        expect(request.url.queryParameters['per_page'], '5');
        expect(request.url.queryParameters['page'], '2');
        expect(request.url.queryParameters['search'], 'hello');
        expect(request.url.queryParameters['categories'], '1');
        expect(request.url.queryParameters['tags'], '3');
        return http.Response(jsonEncode([
          {'id': 1, 'title': {'rendered': 'Test Post'}, 'content': {'rendered': 'Content'}}
        ]), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final posts = await wp.posts.list(perPage: 5, page: 2, search: 'hello', category: 1, tag: 3);
      
      expect(posts, isA<List<Post>>());
      expect(posts.length, 1);
      expect(posts.first.id, 1);
      expect(posts.first.title?['rendered'], 'Test Post');
    });

    test('list returns empty list when response is not a list', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'error': 'invalid'}), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final posts = await wp.posts.list();
      expect(posts, isEmpty);
    });

    test('fetchById returns a single Post', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/posts/10');
        return http.Response(jsonEncode(
          {'id': 10, 'title': {'rendered': 'Single Post'}}
        ), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final post = await wp.posts.fetchById(10);
      
      expect(post.id, 10);
      expect(post.title?['rendered'], 'Single Post');
    });

    test('fetchBySlug returns a single Post', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/posts');
        expect(request.url.queryParameters['slug'], 'hello-world');
        return http.Response(jsonEncode([
          {'id': 20, 'slug': 'hello-world', 'title': {'rendered': 'Hello World'}}
        ]), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final post = await wp.posts.fetchBySlug('hello-world');
      
      expect(post.id, 20);
      expect(post.slug, 'hello-world');
    });

    test('fetchBySlug throws exception if post not found', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode([]), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      expect(() => wp.posts.fetchBySlug('not-found'), throwsA(isA<WordPressException>()));
    });
  });
}
