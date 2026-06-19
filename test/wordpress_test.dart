import 'package:flutter_test/flutter_test.dart';
import 'package:wordpress/wordpress.dart';

void main() {
  group('Live API', () {
    late WordPress wp;

  setUp(() {
    wp = WordPress(baseUrl: "https://blogs.rohitchouhan.com");
  });

  test('Fetch posts list', () async {
    final posts = await wp.posts.list(perPage: 5);
    print(posts.map((p) => p.getFullResponse()));
    expect(posts, isNotEmpty);
    expect(posts.first.title, isNotNull);
  });

  test('Fetch post by ID', () async {
    final posts = await wp.posts.list(perPage: 1);
    print(posts.map((p) => p.getFullResponse()));
    if (posts.isNotEmpty) {
      final post = await wp.posts.fetchById(posts.first.id);
      print(post.getFullResponse());
      expect(post.id, posts.first.id);
    }
  });

  test('Fetch categories', () async {
    final categories = await wp.categories.list();
    print(categories.map((c) => c.getFullResponse()));
    expect(categories, isNotEmpty);
  });

  test('Fetch tags', () async {
    final tags = await wp.tags.list();
    print(tags.map((t) => t.getFullResponse()));
    expect(tags, isList);
  });

  test('Fetch pages', () async {
    final pages = await wp.pages.list(perPage: 5);
    print(pages.map((p) => p.getFullResponse()));
    expect(pages, isList);
  });

  test('Fetch media', () async {
    final media = await wp.media.list();
    print(media.map((m) => m.getFullResponse()));
    expect(media, isList);
  });

  test('Fetch users', () async {
    final users = await wp.users.list();
    print(users.map((u) => u.getFullResponse()));
    expect(users, isList);
  });

  test('Login authentication', () async {
    final user = await wp.auth.login('test', 'test');
    print(user.getFullResponse());
    expect(user, isNotNull);
    expect(user.username, 'test');
  });

  test('Register authentication', () async {
    final user = await wp.auth.register(
      username: 'testuser_${DateTime.now().millisecondsSinceEpoch}',
      email: 'test_${DateTime.now().millisecondsSinceEpoch}@test.com',
      password: 'testpassword123',
    );
    print(user.getFullResponse());
    expect(user, isNotNull);
    expect(user.username, startsWith('testuser_'));
  });

  // Additional auth tests with specific credentials
  test('Login with specific credentials', () async {
    final user = await wp.auth.login('test', 'test');
    print('Login test user: ${user.getFullResponse()}');
    expect(user, isNotNull);
    expect(user.username, 'test');
  });

  test('Register with email test@test.com', () async {
    final user = await wp.auth.register(
      username: 'testuser_email_${DateTime.now().millisecondsSinceEpoch}',
      email: 'test@test.com',
      password: 'testpassword123',
    );
    print('Register test user: ${user.getFullResponse()}');
    expect(user, isNotNull);
  });
  }, skip: 'Live API integration tests. Run manually.');
}
