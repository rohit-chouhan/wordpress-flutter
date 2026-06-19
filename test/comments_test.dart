import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Comments Tests', () {
    test('list returns list of Comments for a post', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/comments');
        expect(request.url.queryParameters['post'], '10');
        return http.Response(
            jsonEncode([
              {
                'id': 1,
                'post': 10,
                'content': {'rendered': 'Great post!'}
              },
              {
                'id': 2,
                'post': 10,
                'content': {'rendered': 'Nice!'}
              }
            ]),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final comments = await wp.comments.list(10);

      expect(comments, isA<List<Comment>>());
      expect(comments.length, 2);
      expect(comments[0].content?['rendered'], 'Great post!');
    });

    test('add creates a new Comment', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/comments');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['post'], 10);
        expect(body['content'], 'My comment');
        return http.Response(
            jsonEncode({
              'id': 3,
              'post': 10,
              'content': {'rendered': 'My comment'}
            }),
            201); // Standard WP usually returns 201 Created for POST comments
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final comment = await wp.comments.add(10, 'My comment');

      expect(comment.id, 3);
      expect(comment.post, 10);
    });
  });
}
