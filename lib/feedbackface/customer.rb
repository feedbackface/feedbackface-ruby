module FeedbackFace
  class Customer
    attr_reader :id, :unique_id, :email, :name, :signed_up_at, :account_id

    def initialize(attributes = {})
      @id = attributes["id"]
      @unique_id = attributes["unique_id"]
      @email = attributes["email"]
      @name = attributes["name"]
      @signed_up_at = attributes["signed_up_at"]
      @account_id = attributes["account_id"]
    end

    def self.create(attributes)
      client = FeedbackFace.new
      client.create_customer(attributes)
    end

    def to_h
      {
        id: id,
        unique_id: unique_id,
        email: email,
        name: name,
        signed_up_at: signed_up_at,
        account_id: account_id
      }
    end
  end
end
