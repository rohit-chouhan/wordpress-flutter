part of 'wordpress_base.dart';

class Users {
  final WordPress wp;

  Users(this.wp);

  /// Gets the current authenticated user's profile.
  ///
  /// Returns the [User] object for the authenticated user.
  Future<User> me() async {
    final headers = wp.getAuthHeaders();
    final response = await wp.get('users/me', headers: headers);
    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }

  /// Updates the current authenticated user's profile.
  ///
  /// [firstName] - New first name.
  /// [lastName] - New last name.
  /// [email] - New email address.
  /// [description] - New user description.
  ///
  /// Returns the updated [User] object.
  Future<User> update({
    String? firstName,
    String? lastName,
    String? email,
    String? description,
  }) async {
    final headers = wp.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final body = <String, dynamic>{};
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (email != null) body['email'] = email;
    if (description != null) body['description'] = description;

    final response = await wp.put(
      'users/me',
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }

  /// Retrieves a list of users.
  ///
  /// Returns a list of [User] objects.
  Future<List<User>> list() async {
    // Users endpoint returns public information, no auth required
    final response = await wp.get('users');
    final data = jsonDecode(response.body) as List;
    return data.map((json) => User.fromJson(json)).toList();
  }
}
