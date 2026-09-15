require 'test_helper'

# Nothing here reaches Twilio, and nothing here stubs a request: the mock answers instead.
# It lives on the module, so a suite arranges what it wants in setup rather than expecting
# the test before it to have left nothing behind.
class MockingTest < Minitest::Test
  def setup = Twi.reset_mock

  def test_a_mocked_phone_is_the_number_that_was_arranged_or_the_error_that_was
    Twi.mock.phone = { id: 'PN1', number: '8009007000' }

    phone = Twi.create_phone area_code: '800'

    assert_equal 'PN1', phone.id
    assert_equal '8009007000', phone.number

    Twi.reset_mock
    Twi.mock.phone_error = { code: 21452, message: 'no number in that area code' }

    assert_equal 21452, assert_raises(Twi::Error) { Twi.create_phone area_code: '800' }.code
  end

  def test_the_mock_records_every_message_and_answers_what_was_arranged
    Twi.mock.message_error = { code: 21610, message: 'the reader unsubscribed' }
    assert_equal 21610, assert_raises(Twi::Error) { Twi.create_message(**text) }.code

    Twi.mock.message = { id: 'SM1', status: 'delivered' }
    message = Twi.create_message(**text)

    assert_equal 'SM1', message.id
    assert_equal 'SM1', message.sid
    assert_equal 'delivered', message.status

    Twi.mock.message = nil
    assert_match(/\ASM/, Twi.create_message(**text).id)
    assert_equal [ text, text, text ], Twi.mock.messages
  end

  def test_a_mocked_conversation_opens_and_is_changed_without_a_network
    conversation = Twi.conversation friendly_name: 'Sue and Bob'
    conversation.create_with participants: []

    assert_match(/\ACH/, conversation.id)
    assert_equal 'initializing', conversation.status

    Twi.mock.conversation = { id: 'CH1', status: 'active' }
    conversation.create_with participants: []

    assert_equal 'CH1', conversation.id
    assert_equal 'active', conversation.status

    Twi.mock.message = { id: 'IM1' }
    assert_equal 'fake-sid', conversation.upload(:photo)
    assert_equal 'IM1', conversation.create_message(content: 'on my way').id
    assert_nil conversation.rename('Sue')
    assert_nil conversation.close
    assert_nil conversation.delete
  end

  def test_a_conversation_the_mock_refuses_raises_the_error_its_code_names
    Twi.mock.conversation_error = { code: 50438, message: 'Existing Conversation CH9' }
    error = assert_raises(Twi::ExistingConversationError) { open_conversation }

    assert_equal 'CH9', error.conversation_id

    Twi.mock.conversation_error = { code: 50214, message: 'too many conversations' }
    assert_raises(Twi::TooManyConversationsError) { open_conversation }
  end

  def test_a_mocked_event_reads_its_images_back_from_the_mock_rather_than_from_twilio
    Twi.mock.medium = { url: 'https://example.com/photo.jpg' }
    params = Twi::MessageEvent.params_for id: 'CH1', participant_id: 'MB1',
      media: [ { id: 'ME1', content_type: 'image/jpeg' } ]

    event = Twi.event ActionController::Parameters.new(params)

    assert_equal [ 'https://example.com/photo.jpg' ], event.image_urls
  end

private

  def text = { sender: '8009007000', recipient: '8008008000', content: 'on my way' }

  def open_conversation = Twi.conversation.create_with participants: []
end
