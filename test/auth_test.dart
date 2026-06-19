import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Auth Tests', () {
    test('login successfully returns User and sets token', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/jwt-auth/v1/token');
        return http.Response(
            jsonEncode({
              'token': 'mocked_jwt_token',
              'user_email': 'test@test.com',
              'user_nicename': 'testuser',
              'user_display_name': 'Test User'
            }),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      final user = await wp.auth.login('testuser', 'password');

      expect(user, isA<User>());
      expect(user.username, 'testuser');
      expect(user.email, 'test@test.com');
      expect(wp.getToken(), 'mocked_jwt_token');
    });

    test('login throws exception on failure', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            jsonEncode(
                {'code': 'invalid_username', 'message': 'Invalid username.'}),
            403);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      expect(() => wp.auth.login('baduser', 'password'),
          throwsA(isA<WordPressException>()));
    });

    test('register successfully returns User', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/users');
        return http.Response(
            jsonEncode({
              'id': 123,
              'username': 'newuser',
              'name': 'New User',
              'email': 'new@test.com'
            }),
            201);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      final user = await wp.auth.register(
          username: 'newuser',
          email: 'new@test.com',
          password: 'password123',
          firstName: 'New',
          lastName: 'User');

      expect(user.id, 123);
      expect(user.username, 'newuser');
      expect(user.email, 'new@test.com');
    });

    test('register throws exception on failure', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Registration failed', 400);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);

      expect(
          () => wp.auth.register(
              username: 'newuser',
              email: 'new@test.com',
              password: 'password123'),
          throwsA(isA<WordPressException>()));
    });

    test('logout clears token', () async {
      final wp = WordPress(baseUrl: 'https://example.com');
      wp.setToken('my_token');
      expect(wp.getToken(), 'my_token');

      await wp.auth.logout();
      expect(wp.getToken(), isNull);
    });
  });
}
