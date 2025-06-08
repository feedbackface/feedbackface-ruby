require "test_helper"

class ClientTest < Minitest::Test
  def setup
    FeedbackFace.configure do |config|
      config.api_key = "test_api_key"
      config.api_base_url = "https://api.feedbackface.com"
      config.account_id = "test_account_id"
    end
  end

  def test_client_initialization_with_api_key
    client = FeedbackFace.new(api_key: "custom_key")
    assert_equal "custom_key", client.api_key
  end

      def test_client_initialization_with_account_id
    client = FeedbackFace.new(account_id: "custom_account")
    assert_equal "custom_account", client.account_id
  end

  def test_client_initialization_uses_global_config
    client = FeedbackFace.new
    assert_equal "test_api_key", client.api_key
    assert_equal "test_account_id", client.account_id
  end

  def test_client_raises_error_without_api_key
    FeedbackFace.configure do |config|
      config.api_key = nil
    end

    assert_raises FeedbackFace::AuthenticationError do
      FeedbackFace.new
    end
  end

        def test_create_customer_raises_error_without_account_id
    client = FeedbackFace.new # account_id will be nil

    assert_raises ArgumentError do
      client.create_customer({email: "test@example.com"})
    end
  end
end
