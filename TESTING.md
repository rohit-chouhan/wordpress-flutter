# WordPress Flutter SDK - Testing Guide

This document outlines the testing strategy, architecture, and coverage goals for the `wordpress-flutter` package.

## Test Architecture
The test suite is located in the `test/` directory. It is structured to mirror the `lib/src/` structure, ensuring that every service file has a corresponding test file.

- `auth_test.dart`
- `categories_test.dart`
- `comments_test.dart`
- `media_test.dart`
- `pages_test.dart`
- `posts_test.dart`
- `tags_test.dart`
- `users_test.dart`
- `wordpress_base_test.dart`

**Mocking Strategy:** 
We use mocked HTTP clients to intercept outgoing requests and return predefined JSON responses. This ensures that tests are fast, reliable, offline-capable, and do not rely on live server data which may change unexpectedly.

## Coverage Goals
We aim for **>90% code coverage** for the entire `lib/` directory. This means testing:
- **Success Scenarios**: Verifying correct parsing of JSON into Dart models.
- **Edge Cases**: Handling null or missing fields gracefully.
- **Error Handling**: Verifying `WordPressException` is thrown appropriately when the server returns 4xx/5xx status codes.
- **Invalid Inputs**: Ensuring invalid parameter combinations are caught.

## How to Run Tests
To run the full test suite, navigate to the root directory and execute:
```bash
flutter test
```

To run tests with coverage reporting:
```bash
flutter test --coverage
```
This generates a `coverage/lcov.info` file. You can visualize it by using tools like `lcov`:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## CI/CD Integration
The test suite is integrated into our GitHub Actions CI pipeline. Every push and pull request triggers a workflow that runs `flutter test --coverage`. If code coverage falls below the required threshold, the build will fail. 

**Workflow Highlights:**
- Tests are run on multiple operating systems (Ubuntu, Windows, macOS).
- Code coverage is analyzed and uploaded as a check.
- The `flutter analyze` command is also run to enforce formatting.

## Testing Best Practices
1. **Arrange-Act-Assert**: All tests should be structured using the AAA pattern. First, set up the mocked client. Second, perform the action. Third, assert the expected outcome.
2. **Mock the API, not the Models**: Always return mock JSON text to test both the `http` request construction and the `json_serializable` parsing logic simultaneously.
3. **Descriptive Descriptions**: Use meaningful descriptions for your `test()` blocks. E.g., `test('throws WordPressException when status code is 404', ...)`
4. **Group Related Tests**: Use the `group()` function to organize tests by endpoint or functionality (e.g., `group('Auth Tests', () { ... })`).
