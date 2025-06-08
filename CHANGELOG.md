# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2024-06-08

### Added

- Initial release of FeedbackFace Ruby gem
- `FeedbackFace.new` client initialization with API key and optional account ID
- `FeedbackFace::Customer.create` for creating customers
- Support for `/api/v1/me` endpoint to get current user information
- Support for `/api/v1/accounts/:account_id/customers` endpoint for customer creation
- Global configuration via `FeedbackFace.configure` block
- Error handling with `FeedbackFace::AuthenticationError` and `FeedbackFace::ValidationError`
- Comprehensive test suite with unit and integration tests
- VCR integration for testing API interactions
- GitHub Actions CI workflow with multi-Ruby version testing (3.0, 3.1, 3.2, 3.3)
- RuboCop linting and security checks
- Automatic release workflow for RubyGems publishing
- Documentation and installation instructions

### Features

- Clean, simple API design
- Account-scoped operations with configurable account ID
- Configurable API base URL for different environments
- JSON response parsing and error handling
- Full test coverage with mocked and real API tests

[Unreleased]: https://github.com/feedbackface/feedbackface-ruby/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/feedbackface/feedbackface-ruby/releases/tag/v0.1.0
