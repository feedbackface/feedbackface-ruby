require_relative "feedbackface/version"
require_relative "feedbackface/client"
require_relative "feedbackface/customer"
require "net/http"
require "json"

module FeedbackFace
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class ValidationError < Error; end

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def new(api_key: nil, account_id: nil)
      Client.new(api_key: api_key, account_id: account_id)
    end
  end

  class Configuration
    attr_accessor :api_key, :api_base_url, :account_id

    def initialize
      @api_base_url = "https://feedbackface.com/api/v1"
    end
  end
end
