$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "feedbackface"

require "minitest/autorun"
require "mocha/minitest"
require "vcr"
require "webmock/minitest"

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: [:method, :uri, :body]
  }

  # Filter sensitive data
  config.filter_sensitive_data('<API_KEY>') { ENV['FEEDBACKFACE_API_KEY'] }
  config.filter_sensitive_data('<ACCOUNT_ID>') { ENV['FEEDBACKFACE_ACCOUNT_ID'] }
end

# Test configuration
FeedbackFace.configure do |config|
  config.api_key = ENV['FEEDBACKFACE_API_KEY'] || 'test_api_key'
  config.api_base_url = ENV['FEEDBACKFACE_API_BASE_URL'] || 'http://localhost:3000'
end

# Disable real HTTP connections
WebMock.disable_net_connect!

class Minitest::Test
  def setup
    # Reset configuration before each test
    FeedbackFace.instance_variable_set(:@config, nil)

    # Set default test configuration
    FeedbackFace.configure do |config|
      config.api_key = "test_api_key"
      config.account_id = "test_account_id"
      config.api_base_url = "https://api.feedbackface.com"
    end
  end

  def teardown
    FeedbackFace.instance_variable_set(:@config, nil)
  end

  def mock_response(body, status = 200)
    response = mock
    response.stubs(:code).returns(status.to_s)
    response.stubs(:body).returns(body.to_json)
    response
  end

  def mock_successful_me_response
    mock_response({
      "id" => "user_123",
      "email" => "test@example.com",
      "name" => "Test User"
    })
  end

  def mock_successful_customer_response
    mock_response({
      "customer" => {
        "id" => "cust_123",
        "unique_id" => "customer123",
        "email" => "customer@example.com",
        "name" => "John Doe",
        "signed_up_at" => "2024-03-20T10:00:00Z"
      }
    })
  end

  def mock_error_response(message, status = 422)
    mock_response({
      "error" => message
    }, status)
  end
end
