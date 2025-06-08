module FeedbackFace
  class Client
    attr_reader :api_key, :account_id

    def initialize(api_key: nil, account_id: nil)
      @api_key = api_key || FeedbackFace.config.api_key
      @account_id = account_id || FeedbackFace.config.account_id
      raise AuthenticationError, "API key is required" unless @api_key
    end

    # Get current user information
    def me
      get("/me")
    end

    # Create a customer
    def create_customer(attributes)
      raise ArgumentError, "Account ID is required" unless @account_id

      response = post("/accounts/#{@account_id}/customers", customer: attributes)
      Customer.new(response["customer"].merge("account_id" => @account_id))
    end

    private

    def get(path)
      request = Net::HTTP::Get.new(path)
      make_request(request)
    end

    def post(path, data)
      request = Net::HTTP::Post.new(path)
      make_request(request, data)
    end

    def make_request(request, data = nil)
      request["Authorization"] = "Bearer #{@api_key}"
      request["Content-Type"] = "application/json"
      request.body = data.to_json if data

      uri = URI(FeedbackFace.config.api_base_url + request.path)
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      handle_response(response)
    end

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      when Net::HTTPUnauthorized
        raise AuthenticationError, "Invalid API key"
      when Net::HTTPUnprocessableEntity
        error = JSON.parse(response.body)
        raise ValidationError, error["error"] || error["errors"].to_s
      else
        raise Error, "Unexpected error: #{response.code} - #{response.body}"
      end
    end
  end
end
