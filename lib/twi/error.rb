module Twi
  class Error < StandardError
    attr_reader :code

    def initialize(attributes = {})
      @code = attributes[:code]
      super attributes[:message]
    end
  end

  class ExistingConversationError < Error
    def conversation_id = message[/Conversation (.+)/, 1]
  end

  class TooManyConversationsError < Error
  end
end
