#!/usr/bin/env ruby

require_relative "lib/feedbackface"
require "json"

# Configure for local testing
FeedbackFace.configure do |config|
  config.api_key = ENV['FEEDBACKFACE_API_KEY'] || 'your_api_key_here'
  config.account_id = ENV['FEEDBACKFACE_ACCOUNT_ID'] || 'acct_123'
  config.api_base_url = 'http://feedbackface.test:3000/api/v1'
end

def test_me_endpoint
  puts "🔍 Testing /api/v1/me endpoint..."
  feedbackface = FeedbackFace.new

  begin
    me = feedbackface.me
    puts "✅ Success! User info:"
    puts JSON.pretty_generate(me)
    puts
    return true
  rescue FeedbackFace::AuthenticationError => e
    puts "❌ Authentication Error: #{e.message}"
    puts "💡 Make sure you set FEEDBACKFACE_API_KEY environment variable"
    return false
  rescue => e
    puts "❌ Error: #{e.message}"
    return false
  end
end

def test_create_customer
  puts "🏗️ Testing customer creation..."

  customer_data = {
    email: "test+#{Time.now.to_i}@example.com",
    unique_id: "test_customer_#{Time.now.to_i}",
    name: "Test Customer #{Time.now.to_i}",
    signed_up_at: Time.now
  }

  begin
    puts "Creating customer with data:"
    puts JSON.pretty_generate(customer_data)

    customer = FeedbackFace::Customer.create(customer_data)

    puts "✅ Success! Customer created:"
    puts "   ID: #{customer.id}"
    puts "   Email: #{customer.email}"
    puts "   Unique ID: #{customer.unique_id}"
    puts "   Name: #{customer.name}"
    puts
    return true
  rescue FeedbackFace::ValidationError => e
    puts "❌ Validation Error: #{e.message}"
    return false
  rescue FeedbackFace::AuthenticationError => e
    puts "❌ Authentication Error: #{e.message}"
    return false
  rescue => e
    puts "❌ Error: #{e.message}"
    return false
  end
end

puts "🚀 FeedbackFace Ruby Gem Local Testing"
puts "=" * 50

# Check if Rails server is running
begin
  require 'net/http'
  uri = URI('http://localhost:3000')
  response = Net::HTTP.get_response(uri)
  puts "✅ Rails server is running on localhost:3000"
rescue => e
  puts "❌ Rails server not accessible on localhost:3000"
  puts "💡 Make sure to start your Rails server with: rails server"
  exit 1
end

puts
puts "Configuration:"
puts "  API Key: #{FeedbackFace.config.api_key}"
puts "  Account ID: #{FeedbackFace.config.account_id}"
puts "  API Base URL: #{FeedbackFace.config.api_base_url}"
puts

success_count = 0
total_tests = 2

success_count += 1 if test_me_endpoint
success_count += 1 if test_create_customer

puts "📊 Results: #{success_count}/#{total_tests} tests passed"

if success_count == total_tests
  puts "🎉 All tests passed! Your FeedbackFace Ruby gem is working correctly."
else
  puts "⚠️  Some tests failed. Check the errors above."
  exit 1
end
