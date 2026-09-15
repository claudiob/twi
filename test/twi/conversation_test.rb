require 'test_helper'

class ConversationTest < Minitest::Test
  # Where Twilio opens a conversation and adds every participant in one request.
  OPEN_URL = %r{conversations\.twilio\.com/v1/Services/.*/ConversationWithParticipants\z}

  def test_a_conversation_opens_with_a_participant_of_each_kind
    stub_request(:post, OPEN_URL).
      to_return body: { sid: 'CH1', state: 'active' }.to_json, headers: JSON_HEADERS

    opened = Twi::Conversation.new friendly_name: 'Sue and Bob'
    opened.create_with participants: participants

    assert_equal 'CH1', opened.id
    assert_equal 'active', opened.status
    assert_requested(:post, OPEN_URL) { |request| joining(request) == expected_participants }
  end

  def test_the_conversation_twilio_already_holds_is_named_by_the_refusal
    stub_refusal 50438, 'Group MMS already exists. Existing Conversation CH9'

    error = assert_raises(Twi::ExistingConversationError) { open_conversation }

    assert_equal 'CH9', error.conversation_id
  end

  def test_an_account_holding_every_conversation_it_may_is_refused_another
    stub_refusal 50214, 'too many conversations'

    assert_raises(Twi::TooManyConversationsError) { open_conversation }
  end

  def test_any_other_refusal_to_open_one_is_left_as_twilio_raised_it
    stub_refusal 20003, 'authentication failed'

    assert_raises(Twilio::REST::RestError) { open_conversation }
  end

  def test_a_conversation_links_to_the_page_the_twilio_console_frames_it_in
    service = ENV['TWILIO_CONVERSATION_SERVICE_SID']
    frame = "/console/conversations/services/#{service}/conversations/CH1"
    console = 'https://console.twilio.com/us1/develop/conversations/manage/services'

    assert_equal "#{console}?frameUrl=#{CGI.escape frame}", Twi::Conversation.new(id: 'CH1').url
  end

private

  def open_conversation = Twi::Conversation.new.create_with participants: []

  def participants = [ { phone: '8009007000' }, { phone: '8008008000', identity: 'agent' } ]

  def expected_participants
    [ '{"messaging_binding":{"address":"+18009007000"}}',
      '{"messaging_binding":{"projected_address":"+18008008000"},"identity":"agent"}', ]
  end

  def joining(request) = all_asked_of request, 'Participant'

  def stub_refusal(code, message)
    stub_request(:post, OPEN_URL).
      to_return status: 400, body: { code: code, message: message }.to_json
  end
end
