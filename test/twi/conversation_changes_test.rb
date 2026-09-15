require 'test_helper'

class ConversationChangesTest < Minitest::Test
  # Where one conversation is renamed, closed or deleted.
  ONE_URL = %r{conversations\.twilio\.com/v1/Services/.*/Conversations/CH1\z}

  # Where a message is added to a conversation.
  MESSAGES_URL = %r{conversations\.twilio\.com/v1/Services/.*/Conversations/CH1/Messages\z}

  # Where a file is uploaded before a message can carry it.
  MEDIA_URL = %r{mcs\.us1\.twilio\.com/v1/Services/.*/Media\z}

  # A stand-in for the file an app uploads, which in a host is an Active Storage blob.
  PHOTO = Data.define(:content_type, :byte_size, :download).new 'image/jpeg', 9, 'the bytes'

  def test_an_open_conversation_is_renamed_closed_and_then_deleted
    stub_request(:post, ONE_URL).to_return body: '{}', headers: JSON_HEADERS
    stub_request(:delete, ONE_URL).to_return status: 204

    conversation.rename 'Sue and Bob'
    conversation.close
    conversation.delete

    assert_requested(:post, ONE_URL) { |sent| asked_of(sent)['FriendlyName'] == 'Sue and Bob' }
    assert_requested(:post, ONE_URL) { |sent| asked_of(sent)['State'] == 'closed' }
    assert_requested :delete, ONE_URL
  end

  def test_a_conversation_twilio_has_already_forgotten_deletes_without_complaint
    stub_deletion 404, 20404

    assert_nil conversation.delete
  end

  def test_a_conversation_twilio_refuses_to_delete_for_any_other_reason_raises
    stub_deletion 401, 20003

    assert_raises(Twilio::REST::RestError) { conversation.delete }
  end

  def test_a_message_carries_the_file_that_was_uploaded_before_it
    stub_request(:post, MEDIA_URL).to_return body: { sid: 'ME1' }.to_json, headers: JSON_HEADERS
    stub_request(:post, MESSAGES_URL).to_return body: '{}', headers: JSON_HEADERS

    id = conversation.upload PHOTO
    conversation.create_message content: 'on my way', image_ids: [ id ]

    assert_equal 'ME1', id
    assert_requested(:post, MEDIA_URL) { |request| request.body == 'the bytes' }
    assert_requested(:post, MESSAGES_URL) { |request| asked_of(request) == expected_message }
  end

private

  def conversation = Twi::Conversation.new id: 'CH1', author: 'agent'

  def expected_message = { 'Author' => 'agent', 'Body' => 'on my way', 'MediaSid' => 'ME1' }

  def stub_deletion(status, code)
    stub_request(:delete, ONE_URL).
      to_return status: status, body: { code: code, message: 'refused' }.to_json
  end
end
