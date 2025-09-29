import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart' as wp;

class PagesScreen extends StatefulWidget {
  final wp.WordPress wordpress;

  const PagesScreen({super.key, required this.wordpress});

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  List<wp.Page> _pages = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPages();
  }

  Future<void> _fetchPages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pages = await widget.wordpress.pages.list(perPage: 20);
      setState(() {
        _pages = pages;
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

  void _navigateToPageDetail(wp.Page page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageDetailScreen(page: page)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _fetchPages,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Fetch Pages'),
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
          child: _pages.isEmpty && !_isLoading
              ? const Center(child: Text('No pages loaded'))
              : ListView.builder(
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          page.title?['rendered'] ?? 'No title',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${page.id} • Author: ${page.author}'),
                            Text('Date: ${page.date} • Status: ${page.status}'),
                            if (page.excerpt?['rendered'] != null)
                              Text(
                                page.excerpt!['rendered']!.replaceAll(
                                  RegExp(r'<[^>]*>'),
                                  '',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.description),
                        onTap: () => _navigateToPageDetail(page),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class PageDetailScreen extends StatelessWidget {
  final wp.Page page;

  const PageDetailScreen({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.title?['rendered'] ?? 'Page Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              page.title?['rendered'] ?? 'No title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('ID: ${page.id}'),
            Text('Author: ${page.author}'),
            Text('Date: ${page.date}'),
            Text('Status: ${page.status}'),
            Text('Parent: ${page.parent}'),
            Text('Menu Order: ${page.menuOrder}'),
            const SizedBox(height: 16),
            if (page.content?['rendered'] != null) ...[
              const Text(
                'Content:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                page.content!['rendered']!.replaceAll(RegExp(r'<[^>]*>'), ''),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Full Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  page.getFullResponse().toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
