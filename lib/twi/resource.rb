# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # An abtract class for all Twilio resources.
  class Resource
    # @param params [ActionController::Parameters] the payload of Twilio hitting a callback URL.
    def initialize(params = {})
      @params = params
    end

  private

    def remove_prefix_from(number) = number&.strip&.delete_prefix '+1'

    def client
      Twilio::REST::Client.new Twi.lio.account_sid, Twi.lio.auth_token
    end

    def messaging_service
      client.messaging.v1.services Twi.lio.messaging_sid.to_s
    end

    def conversation_service
      client.conversations.v1.services Twi.lio.conversation_sid.to_s
    end
  end
end
