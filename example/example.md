Here the example of all method, enjoy coding 😃

```dart
import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';
import 'screens/posts_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/tags_screen.dart';
import 'screens/pages_screen.dart';
import 'screens/media_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/users_screen.dart';

void main() {
  runApp(const WordPressExampleApp());
}

class WordPressExampleApp extends StatelessWidget {
  const WordPressExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordPress Flutter SDK Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 88, 220),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const WordPressHomePage(),
    );
  }
}

class WordPressHomePage extends StatefulWidget {
  const WordPressHomePage({super.key});

  @override
  State<WordPressHomePage> createState() => _WordPressHomePageState();
}

class _WordPressHomePageState extends State<WordPressHomePage> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://blogs.rohitchouhan.com',
  );

  late WordPress _wp;

  @override
  void initState() {
    super.initState();
    _wp = WordPress(baseUrl: _urlController.text);
  }

  void _updateWordPressInstance() {
    setState(() {
      _wp = WordPress(baseUrl: _urlController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WordPress Flutter SDK'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.article), text: 'Posts'),
              Tab(icon: Icon(Icons.category), text: 'Categories'),
              Tab(icon: Icon(Icons.tag), text: 'Tags'),
              Tab(icon: Icon(Icons.description), text: 'Pages'),
              Tab(icon: Icon(Icons.image), text: 'Media'),
              Tab(icon: Icon(Icons.login), text: 'Auth'),
              Tab(icon: Icon(Icons.people), text: 'Users'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'WordPress Base URL',
                        hintText: 'https://your-wordpress-site.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _updateWordPressInstance,
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PostsScreen(wp: _wp),
                  CategoriesScreen(wp: _wp),
                  TagsScreen(wp: _wp),
                  PagesScreen(wordpress: _wp),
                  MediaScreen(wp: _wp),
                  AuthScreen(wp: _wp),
                  UsersScreen(wp: _wp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
```