# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # Provides an object to store global configuration settings.
  #
  # This class is not used directly, but by calling {Twi::Config#configure Twi.configure},
  # which creates and updates a single instance of {Twi::Lio}.
  #
  # @example Set the +sid+ and +secret+ to interact with Twilio API:
  #   Twi.configure do |config|
  #     twilio.sid = 'AC8776d'
  #     twilio.secret = '588213'
  #   end
  #
  # @see Twi::Lio for more examples.
  #
  # An alternative way to set global configuration settings is by storing
  # them in the following environment variables:
  #
  # * +TWILIO_SID+ to store the Twilio SID
  # * +TWILIO_SECRET+ to store the Twilio secret
  # * +TWILIO_CONVERSATION_SERVICE_SID+ to store the Twilio Conversation service ID
  #
  # In case both methods are used together,
  # {Twi::Config#configure Twi.configure} takes precedence.
  #
  # @example Set the +sid+ and +secret+ to interact with Twilio API:
  #   ENV['TWILIO_SID'] = 'AC8776d'
  #   ENV['TWILIO_SECRET'] = '588213'
  #
  class Lio
    # Initialize the global configuration settings defaulting to matching environment variables.
    def initialize
      @api_key = ENV['TWILIO_SID']
      @secret = ENV['TWILIO_SECRET']
      @account_sid = ENV['TWILIO_ACCOUNT_SID']
      @auth_token = ENV['TWILIO_AUTH_TOKEN']
      @conversation_sid = ENV['TWILIO_CONVERSATION_SERVICE_SID']
      @messaging_sid = ENV['TWILIO_MESSAGING_SID']
      @emergency_address_sid = ENV['TWILIO_EMERGENCY_SID']
    end

    # @return [String] API key - used for basic operations like sending messages.
    attr_reader :api_key

    # @return [String] secret - to authenticate API requests made with +api_key+.
    attr_reader :secret

    # @return [String] Account SID - used for advanced operations like creating numbers.
    attr_reader :account_sid

    # @return [String] OAuth token - to authenticate API requests made with +account_sid+.
    attr_reader :auth_token

    # @return [String] the SID of the default Conversation service.
    attr_reader :conversation_sid

    # @return [String] the SID of the default Messaging service.
    attr_reader :messaging_sid

    # @return [String] the SID of the emergency address.
    attr_reader :emergency_address_sid
  end
end
