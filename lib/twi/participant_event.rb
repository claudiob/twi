# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # An event signaling a participant added to a conversation.
  class ParticipantEvent < Event
    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, participant_id:, identity: nil, phone: nil)
      {
        ConversationSid: id, EventType: 'onParticipantChanged',
        ParticipantSid: participant_id.to_s
      }.merge participant_params_for(identity, phone)
    end

  private

    def self.participant_params_for(identity, phone)
      identity ? { Identity: identity } : { 'MessagingBinding.Address' => "+1#{phone}" }
    end
  end
end
