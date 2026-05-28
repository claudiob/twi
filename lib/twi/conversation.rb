# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a (classic) group conversation.
  class Conversation < Resource
    attr_reader :id, :status

    def create_with(participants:)
      params = create_params_for participants
      conversation = conversation_service.conversation_with_participants.create **params

      @id = conversation.sid
      @status = conversation.state
    rescue Twilio::REST::RestError => error
      case error.code
        when 50438 then raise ExistingConversationError.new(error.error_message)
        when 50214 then raise TooManyConversationsError.new(error.error_message)
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
    end

    def create_message(content:, image_ids: [])
      conversation.messages.create **message_params_for(content, image_ids)
    end

  private

    def conversation
      conversation_service.conversations @params[:id]
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
