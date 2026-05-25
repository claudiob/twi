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
      @sid = ENV['TWILIO_SID']
      @secret = ENV['TWILIO_SECRET']
      @conversation_service_sid = ENV['TWILIO_CONVERSATION_SERVICE_SID']
    end

    # @return [String] the SID to interact with the Twilio API.
    attr_reader :sid

    # @return [String] the secret to interact with the Twilio API.
    attr_reader :secret

    # @return [String] the SID of the default Conversation service to use.
    attr_reader :conversation_service_sid
  end
end
