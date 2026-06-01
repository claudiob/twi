# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a direct message delivery notification.
  class Delivery < Resource
    # @return [String] unique identifier
    def id = @params['SmsSid']

    # @return [String] delivery status, one of accepted, scheduled, queued, sending, sent,
    # delivery_unknown, delivered, undelivered, failed # TODO: make an enum
    def status = @params['MessageStatus']

    # @return [String, nil] error code
    def code = @params['ErrorCode']

    # @return [String] documentation URL for given error code.
    def self.url_for(code)
      "https://www.twilio.com/docs/api/errors/#{code}"
    end

    # @return [Boolean] whether the delivery failed because the recipient unsubscribed.
    def self.unsubscribed?(code) = code.eql? '21610'

    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, status:, code: nil)
      { SmsSid: id, MessageStatus: status, ErrorCode: code }
    end
  end
end
