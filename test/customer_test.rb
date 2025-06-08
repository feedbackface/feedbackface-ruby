require "test_helper"

class CustomerTest < Minitest::Test
  def setup
    FeedbackFace.configure do |config|
      config.api_key = "test_api_key"
      config.api_base_url = "https://api.feedbackface.com"
      config.account_id = "test_account_id"
    end
  end

  def test_customer_initialization
    customer_data = {
      "id" => "cust_123",
      "unique_id" => "customer123",
      "email" => "test@example.com",
      "name" => "Test Customer",
      "signed_up_at" => "2024-03-20T10:00:00Z",
      "account_id" => "acct_123"
    }

    customer = FeedbackFace::Customer.new(customer_data)

    assert_equal "cust_123", customer.id
    assert_equal "customer123", customer.unique_id
    assert_equal "test@example.com", customer.email
    assert_equal "Test Customer", customer.name
    assert_equal "2024-03-20T10:00:00Z", customer.signed_up_at
    assert_equal "acct_123", customer.account_id
  end

  def test_customer_to_h
    customer_data = {
      "id" => "cust_123",
      "unique_id" => "customer123",
      "email" => "test@example.com",
      "name" => "Test Customer",
      "signed_up_at" => "2024-03-20T10:00:00Z",
      "account_id" => "acct_123"
    }

    customer = FeedbackFace::Customer.new(customer_data)
    hash = customer.to_h

    expected_hash = {
      id: "cust_123",
      unique_id: "customer123",
      email: "test@example.com",
      name: "Test Customer",
      signed_up_at: "2024-03-20T10:00:00Z",
      account_id: "acct_123"
    }

    assert_equal expected_hash, hash
  end

  def test_customer_create_raises_error_without_account_id
    FeedbackFace.configure do |config|
      config.account_id = nil
    end

    assert_raises ArgumentError do
      FeedbackFace::Customer.create({email: "test@example.com"})
    end
  end
end
