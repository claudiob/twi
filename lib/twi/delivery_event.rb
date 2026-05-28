# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # An event signaling the delivery of a message in a conversation.
  class DeliveryEvent < Event
    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, participant_id:, message_id:, status:, code: nil)
      {
        ConversationSid: id, EventType: 'onDeliveryChanged', ParticipantSid: participant_id.to_s,
        MessageSid: message_id, Status: status.to_s, ErrorCode: code
      }.compact
    end
  end
end
