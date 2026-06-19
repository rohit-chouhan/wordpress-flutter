import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Users Tests', () {
    test('me returns current user profile', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/users/me');
        return http.Response(
            jsonEncode(
                {'id': 1, 'name': 'Admin User', 'email': 'admin@test.com'}),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final user = await wp.users.me();

      expect(user.id, 1);
      expect(user.name, 'Admin User');
    });

    test('update modifies current user profile', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/users/me');
        expect(request.method, 'PUT');
        final body = jsonDecode(request.body);
        expect(body['first_name'], 'Updated');
        return http.Response(
            jsonEncode({'id': 1, 'firstName': 'Updated', 'lastName': 'User'}),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final user =
          await wp.users.update(firstName: 'Updated', lastName: 'User');

      expect(user.firstName, 'Updated');
      expect(user.lastName, 'User');
    });

    test('list returns list of Users', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/wp-json/wp/v2/users');
        return http.Response(
            jsonEncode([
              {'id': 1, 'name': 'User 1'},
              {'id': 2, 'name': 'User 2'}
            ]),
            200);
      });

      final wp = WordPress(baseUrl: 'https://example.com', client: mockClient);
      final users = await wp.users.list();

      expect(users, isA<List<User>>());
      expect(users.length, 2);
    });
  });
}
