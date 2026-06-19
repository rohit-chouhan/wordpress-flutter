import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Categories Tests', () {
    test('list returns list of Categories', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/categories');
        return http.Response(
            jsonEncode([
              {'id': 1, 'name': 'Technology', 'slug': 'tech'},
              {'id': 2, 'name': 'Science', 'slug': 'science'}
            ]),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final categories = await wp.categories.list();

      expect(categories, isA<List<Category>>());
      expect(categories.length, 2);
      expect(categories[0].name, 'Technology');
      expect(categories[1].name, 'Science');
    });

    test('list throws exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      expect(() => wp.categories.list(), throwsA(isA<WordPressException>()));
    });
  });
}
