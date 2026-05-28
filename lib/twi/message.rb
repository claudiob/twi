# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a direct message.
  class Message < Resource
    # @return [String] unique identifier
    def id = @params['MessageSid']

    # @return [String, nil] content
    def content = @params['Body']&.squish

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

    attr_reader :status

    # Sends a message.
    def create
      message = api_client.messages.create messaging_service_sid: Twi.lio.messaging_sid.to_s,
        from: "+1#{@params[:sender]}", to: "+1#{@params[:recipient]}", body: @params[:content]

      @id = message.sid
      @status = message.status
      # todo rescue and then set @code
    end

    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, sender:, recipient:, wallflower: nil, content: nil, opt: nil, media: [])
      {
        MessageSid: id,
        From: "+1#{sender}",
        To: "+1#{recipient}",
        Body: content,
      }.merge media_params_for(media).merge opt_params_for(opt).merge wallflower_params_for(wallflower)
    end

  private

    def self.media_params_for(media = [])
      media.each_with_index.inject({ NumMedia: media.size.to_s }) do |hash, (item, index)|
        url_key = "MediaUrl#{index}".to_sym
        content_type_key = "MediaContentType#{index}".to_sym
        hash.merge url_key => item[:url], content_type_key => item[:content_type]
      end
    end

    def self.opt_params_for(opt = nil)
      case opt
        when :out then { OptOutType: 'STOP' }
        when :in then { OptOutType: 'START' }
        else {}
      end
    end

    def self.wallflower_params_for(wallflower = nil)
      wallflower ? { OtherRecipients0: "+1#{wallflower}" } : {}
    end
  end
end
