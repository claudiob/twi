module Twi
  class Mock
    attr_accessor :phone, :phone_error
    attr_accessor :call, :call_error
    attr_accessor :message, :message_error
    attr_accessor :conversation, :conversation_error
    attr_accessor :medium

    # @return [Array<Hash>] every message sent since the mock was reset, in order.
    def messages = @messages ||= []

    # @return [Array<Hash>] every call placed since the mock was reset, in order.
    def calls = @calls ||= []
  end
end
