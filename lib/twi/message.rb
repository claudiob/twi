# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a direct message.
  class Message
    # @param params [ActionController::Parameters] the payload of Twilio hitting a callback URL.
    def initialize(params = {})
      @params = params
    end

    # @return [String] unique identifier
    def id = @params['MessageSid']

    # @return [Time] sent timestamp
    def sent_at = Time.parse @params['SentDate']

    # @return [String] content
    def body = @params['Body'].squish

    # @return [String] 10-digit phone number sending the SMS.
    def sender = remove_prefix_from @params['From']

    # @return [String] 10-digit phone number receiving the SMS.
    def recipient = remove_prefix_from @params['To']

    # @return [String] 10-digit phone number of any CC'd recipient.
    def wallflower = remove_prefix_from @params['OtherRecipients0']

    # @return [Boolean] whether the sender replied STOP to unsubscribe.
    def opt_out? = @params['OptOutType'] == 'STOP'

    # @return [Boolean] whether the sender replied START to resubscribe.
    def opt_in? = @params['OptOutType'] == 'START'

    # @return [Array<String>] URLs of image attachments
    def image_urls
      (0...@params['NumMedia'].to_i).filter_map do |index|
        @params["MediaUrl#{index}"] if @params["MediaContentType#{index}"].match? %r{^image/}
      end
    end

  private

    def remove_prefix_from(number) = number&.strip&.delete_prefix '+1'
  end
end
