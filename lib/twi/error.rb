module Twi
  class Error < StandardError
  end

  class ExistingConversationError < Error
    def conversation_id = message[/Conversation (.+)/, 1]
  end

  class TooManyConversationsError < Error
  end
end
