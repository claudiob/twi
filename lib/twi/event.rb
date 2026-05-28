# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # An event tied to a (classic) conversation.
  class Event < Resource
    # @return [Symbol] event target type, can be :conversation, :participant, :message, :delivery.
    def target = @params['EventType'].underscore.split('_').second.to_sym

    # @return [String] conversation state, one of active, inactive, closed, initializing.
    def status = @params['Status'] || @params['StateTo'] || @params['State']

    # @return [Participant] the participant the event is about (e.g.: joined the conversation).
    def participant = Participant.new @params

    # @return [String] unique message identifier
    def id = @params['MessageSid']

    # @return [String, nil] content
    def content = @params['Body']&.squish

    # @return [Array<String>] URLs of image attachments
    def image_urls
      media = JSON(@params.fetch('Media', '[]')).map { |params| medium_for params }
      media.filter(&:image?).map { |image| image.url }
    end

    # @return [String] unique conversation identifier
    def conversation_id = @params['ConversationSid']

    # @return [String, nil] error code
    def code = @params['ErrorCode']

    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, type:, status: nil, participant: nil)
      {
        ConversationSid: id, EventType: "on_#{type}_changed".camelize(:lower),
        State: status&.to_s,
      }.merge(participant_params_for participant).compact
    end

    def self.participant_params_for(participant = nil)
      if participant
        if participant[:identity]
          { ParticipantSid: participant[:id], Identity: participant[:identity] }
        else
          { ParticipantSid: participant[:id], 'MessagingBinding.Address' => "+1#{participant[:phone]}" }
        end
      else
        {}
      end
    end

  private

    def medium_for(params) = Medium.new params
  end
end
