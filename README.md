# WordPress Flutter SDK

A comprehensive, production-ready Flutter package for connecting to WordPress websites. This SDK provides complete access to WordPress REST API with type-safe models, authentication, and a fully-featured example app.
![Pub Likes](https://img.shields.io/pub/likes/wordpress)
![Pub Points](https://img.shields.io/pub/points/wordpress)
![Pub Monthly Downloads](https://img.shields.io/pub/dm/wordpress)
![GitHub Issues](https://img.shields.io/github/issues/rohit-chouhan/wordpress-flutter)
![GitHub PRs](https://img.shields.io/github/issues-pr/rohit-chouhan/wordpress-flutter)
![GitHub Forks](https://img.shields.io/github/forks/rohit-chouhan/wordpress-flutter)

[![Rohit Chouhan](https://user-images.githubusercontent.com/82075108/182797964-a92e0c59-b9ef-432d-92af-63b6475a4b1c.svg)](https://www.github.com/rohit-chouhan) 
_[![Sponsor](https://user-images.githubusercontent.com/82075108/182797969-11208ddc-b84c-4618-8534-18388d24ac18.svg)](https://github.com/sponsors/rohit-chouhan)_

## ✨ Features

- 🔐 **Authentication**: JWT-based login/register with profile management
- 📝 **Posts**: Full CRUD operations with search, filtering, and pagination
- 📄 **Pages**: Static page management
- 🏷️ **Categories & Tags**: Complete taxonomy support
- 💬 **Comments**: Read and create comments
- 🖼️ **Media**: Upload and manage media files
- 👤 **Users**: User profiles and management
- 📊 **Type-Safe Models**: Strongly typed Dart objects with `getFullResponse()` method
- 🧪 **Comprehensive Testing**: Full test coverage with real API testing
- 📱 **Example App**: Complete Flutter app demonstrating all features
- ⚡ **Optimized**: Efficient API calls with proper error handling
- `more coming soon`

## 📦 Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  wordpress: ^1.0.0
```

## 🚀 Quick Start

First, create a WordPress client:

```dart
import 'package:wordpress/wordpress.dart';

void main() async {
  // Connect to your WordPress site
  final wp = WordPress(baseUrl: "https://your-wordpress-site.com");

  // Get latest posts with full data
  final posts = await wp.posts.list(perPage: 10);

  // Access complete JSON response
  posts.forEach((post) {
    print(post.getFullResponse()); // Full post data as Map
    print('Title: ${post.title?['rendered']}');
    print('Author: ${post.author}');
  });
}
```

## 📱 Example App

This package includes a **[Complete Flutter WordPress App](https://github.com/rohit-chouhan/wordpress-flutter/tree/main/example)** that demonstrates all features.

The example app includes screens for:
- **Posts**: Browse and search posts with pagination
- **Categories**: View all categories
- **Tags**: Browse post tags
- **Pages**: Static page content
- **Media**: Media library with images
- **Users**: User profiles
- **Authentication**: Login/register functionality

## 📚 Examples

### Getting Posts

```dart
// Get latest 5 posts with full data
final posts = await wp.posts.list(perPage: 5);

// Access complete JSON response
posts.forEach((post) {
  print(post.getFullResponse()); // Full post data as Map
  print('Title: ${post.title?['rendered']}');
  print('Content: ${post.content?['rendered']}');
});

// Get posts from a specific category
final posts = await wp.posts.list(category: 1, perPage: 10);

// Search for posts
final posts = await wp.posts.list(search: "flutter", perPage: 5);

// Get a single post by ID
final post = await wp.posts.fetchById(123);
print('Post details: ${post.getFullResponse()}');

// Get post by slug
final post = await wp.posts.fetchBySlug("my-post-slug");
```

### User Authentication

```dart
// Login user
final user = await wp.auth.login(
  username: "john_doe",
  password: "mypassword123"
);
print("Welcome ${user.name}!");

// Register new user
final newUser = await wp.auth.register(
  username: "newuser",
  email: "newuser@example.com",
  password: "securepassword"
);

// Logout
await wp.auth.logout();
```

### Working with Categories and Tags

```dart
// Get all categories
final categories = await wp.categories.list();

// Get all tags
final tags = await wp.tags.list();
```

### Comments

```dart
// Get comments for a post
final comments = await wp.comments.list(123); // post ID

// Add a comment
final comment = await wp.comments.add(
  123, // post ID
  "This is a great post!",
  authorName: "John Doe",
  authorEmail: "john@example.com"
);
```

### Media Files

```dart
// Get all media files
final media = await wp.media.list();

// Upload a file (requires login)
final uploadedMedia = await wp.media.upload(
  File('path/to/image.jpg'),
  title: "My Photo",
  description: "A beautiful image"
);
```

### User Profile

```dart
// Get current user profile (requires login)
final user = await wp.users.me();

// Update user profile
final updatedUser = await wp.users.update(
  firstName: "John",
  lastName: "Smith",
  description: "Flutter developer"
);

// Get all users (admin only)
final users = await wp.users.list();
```

## Error Handling

The package throws `WordPressException` for API errors:

```dart
try {
  final posts = await wp.posts.list();
} catch (e) {
  if (e is WordPressException) {
    print('WordPress Error: ${e.message}');
    print('Status Code: ${e.statusCode}');
  } else {
    print('Other error: $e');
  }
}
```

## 🔧 Requirements

### WordPress Setup
- **WordPress 4.7+** with REST API enabled (available at `/wp-json/`)
- **Permalinks enabled** in WordPress settings
- **CORS headers** configured for cross-origin requests (if needed)

### Optional Plugins
- **JWT Authentication** - For user authentication features
- **WP REST API** - Enhanced REST API functionality
- **Advanced Custom Fields** - For custom post meta fields

## 🌐 API Endpoints Supported

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/wp-json/wp/v2/posts` | GET | List/search posts |
| `/wp-json/wp/v2/posts/{id}` | GET | Get single post |
| `/wp-json/wp/v2/posts?slug={slug}` | GET | Get post by slug |
| `/wp-json/wp/v2/pages` | GET | List pages |
| `/wp-json/wp/v2/categories` | GET | List categories |
| `/wp-json/wp/v2/tags` | GET | List tags |
| `/wp-json/wp/v2/users` | GET | List users |
| `/wp-json/wp/v2/media` | GET | List media files |
| `/wp-json/wp/v2/comments` | GET/POST | Comments management |
| `/wp-json/jwt-auth/v1/token` | POST | JWT authentication |

## 🛠️ Advanced Usage

### Custom HTTP Client
```dart
// Use custom HTTP client for advanced configuration
final wp = WordPress(
  baseUrl: "https://your-site.com",
  // Custom headers, timeouts, etc.
);
```

### Error Handling
```dart
try {
  final posts = await wp.posts.list();
} on WordPressException catch (e) {
  print('API Error: ${e.message}');
  print('Status: ${e.statusCode}');
  print('Data: ${e.data}');
}
```

### Pagination
```dart
// Handle large datasets with pagination
var page = 1;
while (true) {
  final posts = await wp.posts.list(page: page, perPage: 100);
  if (posts.isEmpty) break;

  // Process posts...
  page++;
}
```
---
# Contributors

Have you found a bug or have a suggestion of how to enhance WhatsApp Package? Open an issue or pull request and we will take a look at it as soon as possible.

# Report bugs or issues

You are welcome to open a _[ticket](https://github.com/rohit-chouhan/wordpress-flutter/issues)_ on github if any problems arise. New ideas are always welcome.

# Copyright and License

> Copyright © 2025 **[Rohit Chouhan](https://rohitchouhan.com)**. Licensed under the _[MIT LICENSE](https://github.com/rohit-chouhan/wordpress-flutter/blob/main/LICENSE)_.
