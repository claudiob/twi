# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a (classic) group conversation.
  class Conversation < Resource
    attr_reader :id, :status

    def create_with(participants:)
      params = create_params_for participants
      conversation = conversation_service.conversation_with_participants.create **params

      @params = { id: conversation.sid, status: conversation.state }
    rescue Twilio::REST::RestError => error
      case error.code
        when 50438 then raise ExistingConversationError.new(code: error.code, message: error.error_message)
        when 50214 then raise TooManyConversationsError.new(code: error.code, message: error.error_message)
        else raise
      end
    end

    def rename(friendly_name)
      conversation.update friendly_name: friendly_name
    end

    def close
      conversation.update state: :closed
    end

    def delete
      conversation.delete
    rescue Twilio::REST::RestError => error
      raise unless error.code == 20404
    end

    def url
      url = "/console/conversations/services/#{Twi.lio.conversation_sid}/conversations/#{id}"
      query = "frameUrl=#{CGI.escape url}"
      "https://console.twilio.com/us1/develop/conversations/manage/services?#{query}"
    end

    def create_message(content:, image_ids: [])
      conversation.messages.create **message_params_for(content, image_ids)
    end

    # TODO: Move into Medium -- this method doesn't use anything from this class
    def upload(file)
      uri = URI "https://mcs.us1.twilio.com/v1/Services/#{Twi.lio.conversation_sid}/Media"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      headers = { 'Content-Type' => file.content_type, 'Content-Size' => file.byte_size.to_s }
      request = Net::HTTP::Post.new uri.request_uri, headers
      request.basic_auth Twi.lio.api_key, Twi.lio.secret
      request.body = file.download
      response = http.request request
      JSON(response.body)['sid']
    end

    def id = @params[:id]

    def status = @params[:status]

  private

    def conversation
      conversation_service.conversations id
    end

    def create_params_for(participants)
      {
        messaging_service_sid: Twi.lio.messaging_sid, x_twilio_webhook_enabled: 'true',
        friendly_name: @params[:friendly_name], participant: participant_params_for(participants),
      }
    end

    def participant_params_for(participants)
      participants.map do |participant|
        phone = "+1#{participant[:phone]}"
        if participant[:identity]
          { messaging_binding: { projected_address: phone }, identity: participant[:identity] }
        else
          { messaging_binding: { address: phone } }
        end
      end.map(&:to_json)
    end

    def message_params_for(content, image_ids)
      {
        author: @params[:author], body: content,
        media_sid: image_ids, x_twilio_webhook_enabled: 'true',
      }.compact_blank
    end
  end
end
