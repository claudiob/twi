module Twi
  class Mock
    attr_accessor :phone, :phone_error
    attr_accessor :message, :message_error
    attr_accessor :conversation, :conversation_error
    attr_accessor :medium

    # @return [Array<Hash>] every message sent since the mock was reset, in order.
    def messages = @messages ||= []
  end
end
