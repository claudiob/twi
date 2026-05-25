# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a participant in a (clasic) conversation.
  class Participant < Resource
    # @return [String] unique identifier.
    def id = @params['ParticipantSid']

    # @return [String] 10-digit phone number.
    def phone = remove_prefix_from @params['MessagingBinding.Address']

    # @return [String, nil] optional identifier.
    def identity = @params['Identity']
  end
end
