require 'test_helper'

class CallTest < Minitest::Test
  # Where Twilio places a call for the account the API key belongs to.
  CALLS_URL = %r{api\.twilio\.com/2010-04-01/Accounts/.*/Calls\.json}

  def test_a_call_is_placed_from_the_sender_to_the_recipient_reading_its_instructions
    stub_call sid: 'CA1', status: 'queued'

    call = Twi::Call.new(sender: '8009007000', recipient: '8008008000',
      url: 'https://example.com/twiml', status_callback: 'https://example.com/status').tap &:create

    assert_equal 'CA1', call.id
    assert_equal 'queued', call.status
    assert_requested(:post, CALLS_URL) { |request| asked_of(request) == expected_call }
  end

  def test_a_call_twilio_refuses_raises_the_code_it_refused_it_with
    stub_request(:post, CALLS_URL).
      to_return status: 400, body: { code: 21215, message: 'not authorized to call' }.to_json

    error = assert_raises(Twi::Error) do
      Twi::Call.new(sender: '8009007000', recipient: '8008008000').create
    end

    assert_equal 21215, error.code
    assert_equal 'not authorized to call', error.message
  end

  def test_the_mock_records_every_call_answers_what_was_arranged_and_reads_a_webhook_back
    Twi.reset_mock
    Twi.mock.call = { id: 'CA2', status: 'ringing' }
    Twi.mock.call_error = { code: 21215, message: 'not authorized to call' }

    error = assert_raises(Twi::Error) { Twi.create_call(**arguments) }
    assert_equal 21215, error.code

    call = Twi.create_call(**arguments)
    assert_equal 'CA2', call.id
    assert_equal 'ringing', call.status
    assert_equal [ arguments, arguments ], Twi.mock.calls

    Twi.mock.call = nil
    assert_match(/\ACA/, Twi.create_call(**arguments).id)
    assert_equal 'queued', Twi.create_call(**arguments).status

    webhook = Twi::Call.params_for(id: 'CA3', status: 'completed', digits: '2').
      merge From: '+18009007000', To: '+18008008000'
    incoming = Twi::Call.new ActionController::Parameters.new(webhook)

    assert_equal 'CA3', incoming.id
    assert_equal 'completed', incoming.status
    assert_equal '2', incoming.digits
    assert_equal '8009007000', incoming.sender
    assert_equal '8008008000', incoming.recipient
  end

private

  def arguments
    { sender: '8009007000', recipient: '8008008000', url: 'https://example.com/twiml',
      status_callback: 'https://example.com/status', }
  end

  # @return [Hash] the fields Twilio takes for the call, as the request carried them.
  def expected_call
    { 'From' => '+18009007000', 'To' => '+18008008000', 'Url' => 'https://example.com/twiml',
      'Method' => 'GET', 'StatusCallback' => 'https://example.com/status', }
  end

  def stub_call(sid:, status:)
    stub_request(:post, CALLS_URL).
      to_return body: { sid: sid, status: status }.to_json,
                headers: { 'Content-Type' => 'application/json' }
  end
end
