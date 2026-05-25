# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of an event tied to a (clasic) conversation.
  class Event < Resource
    # @return [Symbol] what the event is about
    def target
      case @params['EventType']
        when 'onConversationAdded', 'onConversationStateUpdated' then :conversation
        when 'onParticipantAdded' then :participant
        when 'onMessageAdded' then :message
        when 'onDeliveryUpdated' then :delivery
      end
    end

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
      media = JSON(@params.fetch('Media', '[]')).map { |params| Medium.new params }
      media.filter(&:image?).map { |image| image.url }
    end

    # @return [String] unique conversation identifier
    def conversation_id = @params['ConversationSid']

    # @return [String, nil] error code
    def code = @params['ErrorCode']
  end
end
