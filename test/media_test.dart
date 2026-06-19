import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Media Tests', () {
    test('list returns list of Media', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/media');
        return http.Response(
            jsonEncode([
              {'id': 1, 'sourceUrl': 'http://example.com/image.jpg'}
            ]),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final media = await wp.media.list();

      expect(media, isA<List<Media>>());
      expect(media.length, 1);
      expect(media[0].sourceUrl, 'http://example.com/image.jpg');
    });

    test('upload sends multipart request and returns Media', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/media');
        expect(request.method, 'POST');

        // We just intercept the request and return success
        return http.Response(
            jsonEncode({
              'id': 2,
              'title': {'rendered': 'My Image'},
              'sourceUrl': 'http://example.com/uploaded.jpg'
            }),
            201);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      // Create a dummy temporary file
      final tempFile = File('temp_test_image.jpg');
      await tempFile.writeAsBytes([0, 1, 2, 3]);

      try {
        final media = await wp.media.upload(tempFile, title: 'My Image');
        expect(media.id, 2);
        expect(media.title?['rendered'], 'My Image');
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    });
  });
}
