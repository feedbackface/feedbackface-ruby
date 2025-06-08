module FeedbackFace
  class Client
    attr_reader :api_key, :account_id

    def initialize(api_key: nil, account_id: nil)
      @api_key = api_key || FeedbackFace.config.api_key
      @account_id = account_id || FeedbackFace.config.account_id
      raise FeedbackFace::AuthenticationError, "API key is required" unless @api_key
    end

    # Get current user information
    def me
      get("/me")
    end

    # Create a customer
    def create_customer(attributes)
      raise ArgumentError, "Account ID is required" unless @account_id

      response = post("/accounts/#{@account_id}/customers", body: { customer: attributes })
      Customer.new(response["customer"].merge("account_id" => @account_id))
    end

    private

    def get(path, **options)
      make_request(klass: Net::HTTP::Get, path: path, **options)
    end

    def post(path, **options)
      make_request(klass: Net::HTTP::Post, path: path, **options)
    end

    def make_request(klass:, path:, headers: {}, body: nil, query: nil)
      uri = path.start_with?("http") ? URI(path) : URI("#{FeedbackFace.config.api_base_url}#{path}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"

      all_headers = default_headers.merge(headers)
      all_headers.delete("Content-Type") if klass == Net::HTTP::Get

      request = klass.new(uri.request_uri, all_headers)

      if body
        request.body = body.to_json
      end

      handle_response(http.request(request))
    end

    def default_headers
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{api_key}"
      }
    end

    def handle_response(response)
      case response.code
      when "200", "201", "202", "203", "204"
        response.body.empty? ? {} : JSON.parse(response.body)
      when "401"
        raise FeedbackFace::AuthenticationError, "Invalid API key"
      when "404"
        raise FeedbackFace::NotFound, "Resource not found"
      when "422"
        begin
          error = JSON.parse(response.body)
          raise FeedbackFace::ValidationError, error["error"] || error["errors"].to_s
        rescue JSON::ParserError
          raise FeedbackFace::ValidationError, response.body
        end
      when "429"
        raise FeedbackFace::RateLimit, "Rate limit exceeded. Please try again later."
      else
        raise FeedbackFace::Error, "Unexpected error: #{response.code} - #{response.body}"
      end
    end
  end
end
