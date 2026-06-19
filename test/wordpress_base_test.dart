import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('WordPress Base', () {
    test('get method uses client and handles success', () async {
      final mockClient = MockClient((request) async {
        expect(
            request.url.toString(), 'https://example.com/wp-json/wp/v2/test');
        return http.Response(jsonEncode({'success': true}), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final response = await wp.get('test');
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['success'], true);
    });

    test('get method throws WordPressException on error status', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      expect(() => wp.get('test'), throwsA(isA<WordPressException>()));
    });

    test('post method uses client and handles success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        return http.Response(jsonEncode({'id': 1}), 201);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final response = await wp.post('test', body: {'name': 'test'});
      expect(response.statusCode, 201);
    });

    test('put method uses client and handles success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'PUT');
        return http.Response(jsonEncode({'id': 1}), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final response = await wp.put('test/1', body: {'name': 'updated'});
      expect(response.statusCode, 200);
    });

    test('delete method uses client and handles success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'DELETE');
        return http.Response(jsonEncode({'deleted': true}), 200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final response = await wp.delete('test/1');
      expect(response.statusCode, 200);
    });

    test('token management', () {
      final wp = WordPress(baseUrl: 'https://example.com');

      expect(wp.getToken(), isNull);
      expect(wp.getAuthHeaders().isEmpty, true);

      wp.setToken('my_token');
      expect(wp.getToken(), 'my_token');
      expect(wp.getAuthHeaders()['Authorization'], 'Bearer my_token');

      wp.clearToken();
      expect(wp.getToken(), isNull);
      expect(wp.getAuthHeaders().isEmpty, true);
    });
  });
}
