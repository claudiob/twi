require 'test_helper'

class MessageTest < Minitest::Test
  # Where Twilio sends a message for the account the API key belongs to.
  MESSAGES_URL = %r{api\.twilio\.com/2010-04-01/Accounts/.*/Messages\.json}

  def test_a_message_is_sent_through_the_messaging_service_with_whatever_it_carries
    stub_request(:post, MESSAGES_URL).
      to_return body: { sid: 'SM1', status: 'queued' }.to_json, headers: JSON_HEADERS

    message = Twi::Message.new(sender: '8009007000', recipient: '8008008000',
      content: 'on my way', media_url: 'https://example.com/card.vcf').tap &:create

    assert_equal 'SM1', message.id
    assert_equal 'queued', message.status
    assert_requested(:post, MESSAGES_URL) { |request| asked_of(request) == expected_message }
  end

  def test_a_message_twilio_refuses_raises_the_code_it_refused_it_with
    stub_request(:post, MESSAGES_URL).
      to_return status: 400, body: { code: 21610, message: 'the reader unsubscribed' }.to_json

    error = assert_raises(Twi::Error) do
      Twi::Message.new(sender: '8009007000', recipient: '8008008000', content: 'hi').create
    end

    assert_equal 21610, error.code
    assert_equal 'the reader unsubscribed', error.message
  end

  def test_an_inbound_message_names_everyone_on_it_and_the_images_it_carries
    params = Twi::Message.params_for id: 'SM2', sender: '8009007000', recipient: '8008008000',
      wallflower: '8007007000', content: "  on my   way \n ", media: media

    message = Twi::Message.new ActionController::Parameters.new(params)

    assert_equal 'SM2', message.id
    assert_equal 'on my way', message.content
    assert_equal '8009007000', message.sender
    assert_equal '8008008000', message.recipient
    assert_equal '8007007000', message.wallflower
    assert_equal [ 'https://example.com/photo.jpg' ], message.image_urls
  end

  def test_a_message_says_which_way_its_sender_moved_their_subscription
    assert Twi::Message.new(opting(:out)).opt_out?
    assert Twi::Message.new(opting(:in)).opt_in?
    refute Twi::Message.new(opting(nil)).opt_out?
  end

  def test_a_message_links_to_its_own_log_in_the_twilio_console
    logs = 'https://console.twilio.com/us1/monitor/logs/sms'

    assert_equal "#{logs}/#{ENV['TWILIO_ACCOUNT_SID']}/SM1", Twi::Message.url_for('SM1')
  end

private

  def media
    [ { url: 'https://example.com/photo.jpg', content_type: 'image/jpeg' },
      { url: 'https://example.com/notes.pdf', content_type: 'application/pdf' }, ]
  end

  def opting(way)
    ActionController::Parameters.new Twi::Message.params_for(id: 'SM3', sender: '8009007000',
      recipient: '8008008000', opt: way)
  end

  def expected_message
    { 'MessagingServiceSid' => ENV['TWILIO_MESSAGING_SID'], 'From' => '+18009007000',
      'To' => '+18008008000', 'Body' => 'on my way',
      'MediaUrl' => 'https://example.com/card.vcf', }
  end
end
