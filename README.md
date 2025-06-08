# FeedbackFace Ruby Client

A Ruby client for the FeedbackFace API that makes it easy to sync customers with your FeedbackFace account.

## Installation

### From GitHub (Development)

Since this gem is not yet published to RubyGems, you can install it directly from GitHub:

Add this line to your application's Gemfile:

```ruby
gem 'feedbackface', git: 'https://github.com/feedbackface/feedbackface-ruby.git'
```

And then execute:

```bash
$ bundle install
```

### From RubyGems (Coming Soon)

Once published, you'll be able to install it with:

```ruby
gem 'feedbackface'
```

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install feedbackface
```

## Usage

### Configuration

First, configure the client with your API key. In a Rails application, it's recommended to add this configuration to an initializer:

Create `config/initializers/feedbackface.rb`:

```ruby
# config/initializers/feedbackface.rb
FeedbackFace.configure do |config|
  config.api_key = Rails.application.credentials.dig(:feedbackface, :api_key)
  # 1. Go to https://feedbackface.com/accounts
  # 2. Select an account
  # 3. Find your account ID in the url in the format acct_123 (e.g. https://feedbackface.com/accounts/acct_123)
  config.account_id = Rails.application.credentials.dig(:feedbackface, :account_id)
end
```

For non-Rails applications, configure directly:

```ruby
FeedbackFace.configure do |config|
  config.api_key = ENV["FEEDBACKFACE_API_KEY"]
  config.account_id = ENV["FEEDBACKFACE_ACCOUNT_ID"]
end
```

### Get Current User Information

```ruby
feedbackface = FeedbackFace.new

# Get current user information
me = feedbackface.me
puts me["email"] # => "user@example.com"
```

### Creating a Customer

```ruby
customer = FeedbackFace::Customer.create({
  email: "customer@example.com",
  unique_id: "customer123",
  name: "John Doe",
  signed_up_at: Time.current
})

puts customer.id          # => "cust_123"
puts customer.email       # => "customer@example.com"
puts customer.unique_id   # => "customer123"
puts customer.name        # => "John Doe"
```

## Error Handling

The client raises the following exceptions:

- `FeedbackFace::AuthenticationError` - When the API key is invalid or missing
- `FeedbackFace::ValidationError` - When the customer data is invalid
- `FeedbackFace::Error` - For other unexpected errors

Example:

```ruby
begin
  customer = FeedbackFace::Customer.create({
    email: "invalid-email",
    unique_id: "customer123"
  })
rescue FeedbackFace::ValidationError => e
  puts "Validation failed: #{e.message}"
rescue FeedbackFace::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue FeedbackFace::Error => e
  puts "Unexpected error: #{e.message}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feedbackface/feedbackface-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FeedbackFace::Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/feedbackface/feedbackface-ruby/blob/master/CODE_OF_CONDUCT.md).
