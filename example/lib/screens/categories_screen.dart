import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';

class CategoriesScreen extends StatefulWidget {
  final WordPress wp;

  const CategoriesScreen({super.key, required this.wp});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final categories = await widget.wp.categories.list();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _fetchCategories,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Fetch Categories'),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: _categories.isEmpty && !_isLoading
              ? const Center(child: Text('No categories loaded'))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(category.name ?? 'No name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${category.id}'),
                            Text('Count: ${category.count}'),
                            Text('Slug: ${category.slug}'),
                            if (category.description?.isNotEmpty == true)
                              Text('Description: ${category.description}'),
                          ],
                        ),
                        trailing: const Icon(Icons.category),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
