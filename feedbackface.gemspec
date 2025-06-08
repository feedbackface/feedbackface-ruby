# frozen_string_literal: true

require_relative "lib/feedbackface/version"

Gem::Specification.new do |spec|
  spec.name = "feedbackface"
  spec.version = FeedbackFace::VERSION
  spec.authors = ["Rinas Muhammed"]
  spec.email = ["rinas@feedbackface.com"]

  spec.summary = "Ruby client for the FeedbackFace API"
  spec.description = "A Ruby client for interacting with the FeedbackFace API, providing easy customer synchronization."
  spec.homepage = "https://github.com/feedbackface/feedbackface-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 2.6"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 2.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "bundler-audit", "~> 0.9"
end
