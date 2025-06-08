require "test_helper"

class IntegrationTest < Minitest::Test
    def setup
    FeedbackFace.configure do |config|
      config.api_key = ENV["FEEDBACKFACE_API_KEY"] || "test_api_key_123"
      config.account_id = ENV["FEEDBACKFACE_ACCOUNT_ID"] || "acct_test123"
      config.api_base_url = ENV["FEEDBACKFACE_API_URL"] || "http://localhost:3000"
    end

    @client = FeedbackFace.new
  end

  def test_me_endpoint
    VCR.use_cassette("me_endpoint") do
      me = @client.me

      assert_kind_of Hash, me
      assert me.key?("id")
      assert me.key?("name")
    end
  end

  def test_create_customer
    VCR.use_cassette("create_customer") do
      customer_data = {
        email: "test@example.com",
        unique_id: "test_customer_#{Time.now.to_i}",
        name: "Test Customer",
        signed_up_at: Time.now
      }

      customer = @client.create_customer(customer_data)

      assert_kind_of FeedbackFace::Customer, customer
      assert_equal customer_data[:email], customer.email
      assert_equal customer_data[:unique_id], customer.unique_id
      assert_equal customer_data[:name], customer.name
      assert customer.id
    end
  end

  def test_authentication_error
    VCR.use_cassette("authentication_error") do
      client = FeedbackFace.new(api_key: "invalid_api_key")

      assert_raises FeedbackFace::AuthenticationError do
        client.me
      end
    end
  end

  def test_validation_error
    VCR.use_cassette("validation_error") do
      # Invalid email format
      invalid_customer_data = {
        email: "invalid-email",
        unique_id: "test_customer",
        name: "Test Customer"
      }

      assert_raises FeedbackFace::ValidationError do
        FeedbackFace::Customer.create(invalid_customer_data)
      end
    end
  end
end
