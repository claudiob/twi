# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # Provides methods to read and write global configuration settings.
  #
  # A typical usage is to set the +sid+ and +secret+ to interact with Twilio API.
  #
  # @example Set the +sid+ and +secret+ to interact with Twilio API:
  #   Twi.configure do |twilio|
  #     twilio.sid = 'AC8776d'
  #     twilio.secret = '588213'
  #   end
  #
  # Note that Twi.configure has precedence over values through with
  # environment variables (see {Twi::Lio}).
  #
  module Config
    # Yields the global configuration to the given block.
    #
    # @example
    #   Twi.configure do |twilio|
    #     twilio.sid = 'AC8776d'
    #   end
    #
    # @yield [Twi::Lio] The global configuration.
    def configure
      yield lio if block_given?
    end

    # @return [Twi::Lio] The global configuration.
    def lio
      @lio ||= Twi::Lio.new
    end
  end

  # @note Config is tauto-loaded in the Twi module to be able to invoke +Twi.configure+.
  extend Config
end
