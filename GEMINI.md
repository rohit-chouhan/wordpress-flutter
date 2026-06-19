# WordPress Flutter SDK - Contributor Guide (GEMINI)

Welcome to the `wordpress-flutter` package! This document serves as the primary contributor guide, detailing the project's architecture, coding standards, and best practices. Whether you are adding a new feature or fixing a bug, please follow these guidelines closely.

## 1. Project Overview
The `wordpress-flutter` package provides a comprehensive, production-ready SDK for connecting Flutter applications to WordPress sites via the REST API. It offers type-safe models, full CRUD operations across all standard endpoints (Posts, Pages, Categories, Tags, Media, Comments, Users), and secure JWT authentication. 

## 2. Architecture Guidelines
The core architecture consists of a base client (`WordPressBase` / `WordPress`) that manages HTTP connections, authentication, and headers.
- **Service Classes**: Endpoints are divided into isolated service classes (e.g., `WordPressPosts`, `WordPressAuth`, `WordPressMedia`). Each service class accepts a reference to the `WordPressBase` instance to perform authenticated requests.
- **Models**: We use `json_serializable` to generate type-safe Dart models for all WordPress objects (e.g., `Post`, `User`, `Comment`).
- **Data Encapsulation**: A `getFullResponse()` method is often provided on models to expose the raw JSON for advanced use cases where the typed model may not map all custom fields.

## 3. Coding Standards
- Write clean, strongly-typed Dart code. Use `final` where variables shouldn't change.
- Enable and strictly adhere to the project's `analysis_options.yaml`.
- Handle exceptions specifically using the `WordPressException` class, ensuring appropriate status codes and error messages are returned to the user.
- Prefer asynchronous operations (`async`/`await`) for all API communications.

## 4. Folder Structure Explanation
- `/lib`: Contains the main entry point (`wordpress.dart`).
- `/lib/src`: Contains all internal implementation files:
  - `/lib/src/models.dart`: JSON models and `json_serializable` parts.
  - `/lib/src/exception.dart`: Custom exceptions.
  - `/lib/src/<feature>.dart`: Service classes for different endpoints.
- `/test`: Comprehensive unit and integration tests for every public API.
- `/example`: A fully-featured Flutter application demonstrating package usage.

## 5. Naming Conventions
- **Classes**: PascalCase (e.g., `WordPressException`, `WordPressPosts`).
- **Files**: snake_case (e.g., `wordpress_base.dart`).
- **Variables/Methods**: camelCase (e.g., `fetchById`, `baseUrl`).
- **Models**: Named directly after the WordPress object (e.g., `Post`, `Category`, `Media`).

## 6. API Design Principles
- Every new endpoint added should have a corresponding service class or be grouped logically within an existing one.
- Provide sensible defaults for optional query parameters (like `page`, `perPage`).
- Document public APIs using Dart `///` docstrings, specifying what parameters do and what errors can be thrown.
- Return structured models rather than raw maps, except when providing a fallback like `getFullResponse()`.

## 7. Testing Requirements
- Every public API **must** have corresponding test coverage.
- Use the Arrange-Act-Assert testing pattern.
- Strive for >90% code coverage across the SDK.
- Use mocked HTTP clients where appropriate to ensure tests run reliably offline and in CI environments. 
- Ensure edge cases, invalid inputs, and error handling paths are tested.

## 8. Documentation Requirements
When making code changes, always keep the documentation up-to-date:
- Document all public methods, classes, and properties with `///` docstrings.
- Provide small inline examples in the docstrings for complex functions.

## 9. Release Process
1. Update `version` in `pubspec.yaml` following Semantic Versioning.
2. Document all changes in `CHANGELOG.md`.
3. Verify that all tests pass (`flutter test`).
4. Format code using `dart format .` and check for issues with `flutter analyze`.
5. Run `flutter pub publish --dry-run` to catch pub.dev publication issues.
6. Trigger the publishing action or push a release tag.

## 10. Pull Request Guidelines
- Keep Pull Requests small and focused on a single feature or bugfix.
- Reference the GitHub issue the PR resolves.
- Ensure the CI workflow passes successfully.
- Request reviews from maintainers and address any feedback promptly.

## 11. Versioning Strategy
We strictly adhere to [Semantic Versioning (SemVer)](https://semver.org/).
- **Major (X.y.z)**: Breaking changes to public APIs.
- **Minor (x.Y.z)**: Backward-compatible new features.
- **Patch (x.y.Z)**: Backward-compatible bug fixes.

## 12. Contribution Guidelines
- Fork the repository and create your feature branch from `main`.
- Write your code according to the standards outlined in this guide.
- Commit your changes with descriptive messages.
- Push your branch and open a Pull Request against `main`.

## 13. Best Practices for Future Development
- **Extensibility**: Make it easy for users to add interceptors or custom headers.
- **Performance**: Keep parsing light and avoid blocking the main thread for heavy JSON decoding.
- **Reliability**: Fail gracefully with actionable error messages when the WordPress server returns unexpected HTML or 5xx errors.

---

> [!IMPORTANT]
> **Mandatory Checklist for Code Changes**
> Whenever you make code changes, you MUST ensure the following:
> 1. **`README.md` must be updated** if any user-facing functionality changes.
> 2. **`CHANGELOG.md` must be updated** following semantic versioning.
> 3. **Examples must be updated** in the `/example` app when APIs change.
> 4. **Tests must be added or updated** in the `/test` directory to cover your changes.
