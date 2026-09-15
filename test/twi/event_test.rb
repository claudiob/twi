require 'test_helper'

class EventTest < Minitest::Test
  # Where a conversation's media is read back, one medium at a time.
  MEDIA_URL = %r{mcs\.us1\.twilio\.com/v1/Services/.*/Media/ME1\z}

  def test_a_message_event_names_its_conversation_its_words_and_the_images_on_it
    stub_medium 'https://example.com/photo.jpg'
    params = Twi::MessageEvent.params_for id: 'CH1', participant_id: 'MB1',
      content: "  on my   way \n ", media: media

    event = Twi::Event.new ActionController::Parameters.new(params)

    assert_equal 'CH1', event.conversation_id
    assert_equal 'on my way', event.content
    assert_match(/\ASM/, event.id)
    assert_equal [ 'https://example.com/photo.jpg' ], event.image_urls
    assert_equal 'MB1', event.participant.id
    # What the event is about, read off its name with a method Rails brings and a gem must ask for.
    assert_equal :message, event.target
  end

  def test_a_message_event_with_nothing_attached_carries_no_media_at_all
    params = Twi::MessageEvent.params_for id: 'CH1', participant_id: 'MB1', content: 'on my way'

    event = Twi::Event.new ActionController::Parameters.new(params)

    assert_empty event.image_urls
  end

  def test_a_participant_event_names_whichever_handle_the_participant_joined_under
    dialed = Twi::ParticipantEvent.params_for id: 'CH1', participant_id: 'MB1', phone: '8009007000'
    named = Twi::ParticipantEvent.params_for id: 'CH1', participant_id: 'MB2', identity: 'agent'

    assert_equal 'MB1', event_from(dialed).participant.id
    assert_equal '8009007000', event_from(dialed).participant.phone
    assert_equal 'agent', event_from(named).participant.identity
  end

  def test_a_conversation_event_names_the_state_the_conversation_moved_to
    event = event_from Twi::ConversationEvent.params_for(id: 'CH1', status: :closed)

    assert_equal 'CH1', event.conversation_id
    assert_equal 'closed', event.status
  end

  def test_a_delivery_event_names_the_message_it_reports_on_and_why_it_failed
    params = Twi::DeliveryEvent.params_for id: 'CH1', participant_id: 'MB1', message_id: 'IM1',
      status: :undelivered, code: '30008'

    event = event_from params

    assert_equal 'IM1', event.id
    assert_equal 'undelivered', event.status
    assert_equal '30008', event.code
  end

  def test_an_event_built_by_hand_carries_whatever_its_participant_is_known_by
    dialed = { id: 'MB1', phone: '8009007000' }
    named = { id: 'MB2', identity: 'agent' }

    assert_equal '+18009007000', event_params(participant: dialed)['MessagingBinding.Address']
    assert_equal 'agent', event_params(participant: named)[:Identity]
    assert_equal 'active', event_params(status: :active)[:State]
  end

private

  def media
    [ { id: 'ME1', content_type: 'image/jpeg' }, { id: 'ME2', content_type: 'application/pdf' } ]
  end

  def event_from(params) = Twi::Event.new ActionController::Parameters.new(params)

  def event_params(participant: nil, status: nil)
    Twi::Event.params_for id: 'CH1', type: :participant, participant: participant, status: status
  end

  def stub_medium(url)
    stub_request(:get, MEDIA_URL).to_return headers: JSON_HEADERS,
      body: { links: { content_direct_temporary: url } }.to_json
  end
end
