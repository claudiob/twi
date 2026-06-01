module Twi
  class Mock::Conversation < Conversation
    def create_with(participants:)
      if error = Twi.mock.conversation_error
        Twi.mock.conversation_error = nil
        case error[:code]
          when 50438 then raise ExistingConversationError.new(error)
          when 50214 then raise TooManyConversationsError.new(error)
        end
      elsif Twi.mock.conversation
        @id = Twi.mock.conversation[:id]
        @status = Twi.mock.conversation[:status]
      end
    end

    def upload(file) = 'fake-sid'

    def rename(friendly_name); end

    def close; end

    def delete; end

    def create_message(content:, image_ids: [])
      Mock::Message.new Twi.mock.message
    end
  end
end
