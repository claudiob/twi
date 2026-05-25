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
  end
end
