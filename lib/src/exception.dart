/// Exception thrown when a WordPress API request fails.
class WordPressException implements Exception {
  /// The error message.
  final String message;

  /// The HTTP status code, if available.
  final int? statusCode;

  /// Additional data from the response, if available.
  final dynamic data;

  /// Creates a new WordPressException.
  WordPressException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    return 'WordPressException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}
