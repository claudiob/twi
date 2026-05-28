# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # An event signaling a new message in a conversation.
  class MessageEvent < Event
    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, participant_id:, content: nil, media: [])
      {
        ConversationSid: id, EventType: 'onMessageChanged', ParticipantSid: participant_id.to_s,
        MessageSid: "SM#{rand}", Body: content, Media: media_params_for(media),
      }.compact_blank
    end

  private

    def self.media_params_for(media)
      media.map do |medium|
        { Sid: medium[:id], ContentType: medium[:content_type] }
      end.to_json if media.present?
    end
  end
end
