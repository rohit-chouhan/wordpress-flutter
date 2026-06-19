import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Tags Tests', () {
    test('list returns list of Tags', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/tags');
        return http.Response(
            jsonEncode([
              {'id': 10, 'name': 'Flutter', 'slug': 'flutter'},
              {'id': 20, 'name': 'Dart', 'slug': 'dart'}
            ]),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final tags = await wp.tags.list();

      expect(tags, isA<List<Tag>>());
      expect(tags.length, 2);
      expect(tags[0].name, 'Flutter');
      expect(tags[1].name, 'Dart');
    });

    test('list throws exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      expect(() => wp.tags.list(), throwsA(isA<WordPressException>()));
    });
  });
}
