## 1.0.1

### 🐛 Bug Fixes
- **Auth Endpoint Leak**: Fixed `Auth.login` and `Auth.register` to use the injected HTTP client, allowing for proper interception and mocking.
- **Media Upload Leak**: Fixed `MediaModule.upload` to use the injected HTTP client rather than the global `http` client.

### 🧪 Testing & Documentation
- **Comprehensive Offline Test Suite**: Added `MockClient`-based tests for all endpoints (`auth`, `categories`, `comments`, `media`, `pages`, `posts`, `tags`, `users`, `wordpress_base`), ensuring reliable CI builds without hitting live servers.
- Added `GEMINI.md` contributor guide and `TESTING.md` test architecture documentation.

---

## 1.0.0

### 🚀 Major Release - Production Ready

This is a major release that transforms the WordPress Flutter package into a comprehensive, production-ready SDK with complete WordPress REST API support.

### ✨ New Features

- **Complete WordPress REST API Support**: Full implementation of all major WordPress endpoints
  - Posts (list, search, filter, pagination)
  - Pages (static content)
  - Categories & Tags (taxonomy management)
  - Users (profiles and management)
  - Media (file uploads and management)
  - Comments (read and create)
  - Authentication (JWT-based login/register)

- **Type-Safe Data Models**: Strongly typed Dart objects for all WordPress data
  - `Post`, `Page`, `User`, `Category`, `Tag`, `Comment`, `Media` models
  - Automatic JSON serialization/deserialization
  - **`getFullResponse()` method** - Access complete JSON data for each model

- **Comprehensive Example App**: Complete Flutter application demonstrating all features
  - Posts browser with search and pagination
  - Categories, Tags, Pages, Media, and Users screens
  - Authentication flow (login/register)
  - Real-time data display with full JSON access

- **Advanced Testing Suite**: Production-quality test coverage
  - Unit tests for all API endpoints
  - Integration tests with real WordPress API
  - Widget tests for example app
  - Error handling validation

### 🔧 Improvements

- **Fixed Model Field Types**: Corrected `meta` field types across all models
  - Posts/Pages/Users/Comments/Media: `Map<String, dynamic>? meta`
  - Categories/Tags: `List<dynamic>? meta`

- **Enhanced Error Handling**: Robust `WordPressException` with status codes and data

- **Optimized API Calls**: Efficient HTTP requests with proper error handling

- **Production-Ready Code**: Clean architecture with separation of concerns

### 🐛 Bug Fixes

- **Fixed Posts Loading Issue**: Corrected pagination logic in example app
- **Model Serialization**: Fixed JSON parsing for all WordPress data types
- **Authentication Flow**: Improved login/register error handling

### 📚 Documentation

- **Comprehensive README**: Complete documentation with examples
- **API Reference**: All supported endpoints documented
- **Installation Guide**: Step-by-step setup instructions
- **Usage Examples**: Real-world code examples
- **Testing Guide**: How to run and extend tests

### 🧪 Testing

- **Real API Testing**: Tests run against live WordPress site
- **Complete Coverage**: All endpoints and error scenarios tested
- **Widget Testing**: Example app UI validation
- **Integration Tests**: End-to-end functionality verification

### 📦 Breaking Changes

- **Model Field Types**: `meta` field type changes (see improvements above)
- **API Response Format**: Enhanced error handling may affect error responses

### 🎯 Migration Guide

If upgrading from 0.0.1:

1. Update `meta` field usage in your code to match new types
2. Use `getFullResponse()` method to access complete JSON data
3. Update error handling to use `WordPressException`

### 🙏 Acknowledgments

- WordPress REST API team for comprehensive documentation
- Flutter community for excellent framework
- All contributors and testers

---

## 0.0.1

* Initial release with basic WordPress connectivity
