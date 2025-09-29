import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';

class TagsScreen extends StatefulWidget {
  final WordPress wp;

  const TagsScreen({super.key, required this.wp});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  List<Tag> _tags = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  Future<void> _fetchTags() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tags = await widget.wp.tags.list();
      setState(() {
        _tags = tags;
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
            onPressed: _isLoading ? null : _fetchTags,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Fetch Tags'),
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
          child: _tags.isEmpty && !_isLoading
              ? const Center(child: Text('No tags loaded'))
              : ListView.builder(
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(tag.name ?? 'No name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${tag.id}'),
                            Text('Count: ${tag.count}'),
                            Text('Slug: ${tag.slug}'),
                            if (tag.description?.isNotEmpty == true)
                              Text('Description: ${tag.description}'),
                          ],
                        ),
                        trailing: const Icon(Icons.tag),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
