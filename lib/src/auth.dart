part of 'wordpress_base.dart';

class Auth {
  final WordPress wp;

  Auth(this.wp);

  /// Logs in a user with username and password using JWT authentication.
  ///
  /// Returns a [User] object on successful login.
  /// Throws [WordPressException] on failure.
  Future<User> login(String username, String password) async {
    final url = Uri.parse('${wp.baseUrl}/wp-json/jwt-auth/v1/token');
    final response = await wp._client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      wp.setToken(token);

      // Create user object from JWT response
      final user = User(
        id: 0, // Will be fetched from /users/me endpoint
        username: data['user_nicename'] ?? data['user_login'] ?? username,
        name: data['user_display_name'] ?? username,
        email: data['user_email'],
        firstName: null,
        lastName: null,
        url: null,
        description: null,
        link: null,
        locale: null,
        nickname: data['user_nicename'],
        slug: null,
        roles: null,
        registeredDate: null,
        capabilities: null,
        extraCapabilities: null,
        meta: null,
        avatarUrls: null,
        links: null,
      );
      return user;
    } else {
      throw WordPressException('Login failed',
          statusCode: response.statusCode, data: response.body);
    }
  }

  /// Registers a new user with the provided details.
  ///
  /// Returns a [User] object on successful registration.
  /// Throws [WordPressException] on failure.
  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final url = Uri.parse('${wp.apiBase}/users');
    final body = {
      'username': username,
      'email': email,
      'password': password,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    };

    final response = await wp._client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw WordPressException('Registration failed',
          statusCode: response.statusCode, data: response.body);
    }
  }

  /// Logs out the current user by clearing the authentication token.
  Future<void> logout() async {
    wp.clearToken();
  }
}
