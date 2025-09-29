import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';

class MediaScreen extends StatefulWidget {
  final WordPress wp;

  const MediaScreen({super.key, required this.wp});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  List<Media> _media = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final media = await widget.wp.media.list();
      setState(() {
        _media = media;
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

  void _navigateToMediaDetail(Media media) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MediaDetailScreen(media: media)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _fetchMedia,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Fetch Media'),
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
          child: _media.isEmpty && !_isLoading
              ? const Center(child: Text('No media loaded'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _media.length,
                  itemBuilder: (context, index) {
                    final media = _media[index];
                    return Card(
                      child: InkWell(
                        onTap: () => _navigateToMediaDetail(media),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: media.sourceUrl != null
                                  ? Image.network(
                                      media.sourceUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 48,
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 48),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    media.title?['rendered'] ?? 'No title',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('ID: ${media.id}'),
                                  Text('Type: ${media.mediaType}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class MediaDetailScreen extends StatelessWidget {
  final Media media;

  const MediaDetailScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(media.title?['rendered'] ?? 'Media Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media.sourceUrl != null)
              Image.network(
                media.sourceUrl!,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 48),
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              media.title?['rendered'] ?? 'No title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('ID: ${media.id}'),
            Text('Date: ${media.date}'),
            Text('Author: ${media.author}'),
            Text('Media Type: ${media.mediaType}'),
            Text('MIME Type: ${media.mimeType}'),
            Text('Alt Text: ${media.altText}'),
            if (media.caption?['rendered'] != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Caption:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                media.caption!['rendered']!.replaceAll(RegExp(r'<[^>]*>'), ''),
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
                  media.getFullResponse().toString(),
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
