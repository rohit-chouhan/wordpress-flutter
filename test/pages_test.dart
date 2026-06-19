import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Pages Tests', () {
    test('list returns list of Pages', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/pages');
        expect(request.url.queryParameters['per_page'], '10');
        expect(request.url.queryParameters['page'], '1');
        expect(request.url.queryParameters['search'], 'about');
        return http.Response(jsonEncode([
          {'id': 100, 'title': {'rendered': 'About Us'}, 'content': {'rendered': 'Content'}}
        ]), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final pages = await wp.pages.list(perPage: 10, page: 1, search: 'about');
      
      expect(pages, isA<List<Page>>());
      expect(pages.length, 1);
      expect(pages[0].title?['rendered'], 'About Us');
    });

    test('fetchById returns a single Page', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/pages/100');
        return http.Response(jsonEncode(
          {'id': 100, 'title': {'rendered': 'Contact'}}
        ), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final page = await wp.pages.fetchById(100);
      
      expect(page.id, 100);
      expect(page.title?['rendered'], 'Contact');
    });

    test('fetchById throws exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      
      expect(() => wp.pages.fetchById(999), throwsA(isA<WordPressException>()));
    });
  });
}
