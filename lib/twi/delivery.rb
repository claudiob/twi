# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a direct message delivery notification.
  class Delivery
    # @param params [ActionController::Parameters] the payload of Twilio hitting a callback URL.
    def initialize(params = {})
      @params = params
    end

    # @return [String] unique identifier
    def id = @params['SmsSid']

    # @return [String] delivery status, one of accepted, scheduled, queued, sending, sent,
    # delivery_unknown, delivered, undelivered, failed # TODO: make an enum
    def status = @params['MessageStatus']

    # @return [String, nil] error code
    def code = @params['ErrorCode']

    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, status:, code: nil)
      { SmsSid: id, MessageStatus: status, ErrorCode: code }
    end
  end
end
