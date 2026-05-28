# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # An event signaling a status change for a conversation.
  class ConversationEvent < Event
    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, status:)
      { ConversationSid: id, EventType: 'onConversationChanged', State: status.to_s }
    end
  end
end
