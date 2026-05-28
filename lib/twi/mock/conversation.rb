module Twi
  class Mock::Conversation < Conversation
    def create_with(participants:)
      if Twi.mock.conversation_error
        if Twi.mock.conversation_error[:code] == 50438
          raise ExistingConversationError.new(Twi.mock.conversation_error[:message])
        elsif Twi.mock.conversation_error[:code] == 50214
          Twi.mock.conversation_error = nil
          raise TooManyConversationsError
        end
      elsif Twi.mock.conversation
        @id = Twi.mock.conversation[:id]
        @status = Twi.mock.conversation[:status]
      end
    end

    def rename(friendly_name); end

    def close; end

    def delete; end

    def create_message(content:, image_ids: [])
      Mock::Message.new Twi.mock.message if Twi.mock.message
    end
  end
end
