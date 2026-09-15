require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'webmock/minitest'

ENV['TWILIO_SID'] = 'AC00000000000000000000000000000000'
ENV['TWILIO_SECRET'] = 'secret'
ENV['TWILIO_ACCOUNT_SID'] = 'AC11111111111111111111111111111111'
ENV['TWILIO_AUTH_TOKEN'] = 'auth-token'
ENV['TWILIO_CONVERSATION_SERVICE_SID'] = 'IS00000000000000000000000000000000'
ENV['TWILIO_MESSAGING_SID'] = 'MG00000000000000000000000000000000'
ENV['TWILIO_EMERGENCY_SID'] = 'AD00000000000000000000000000000000'

require_relative '../lib/twi'

# What every test needs to answer Twilio and to read back what it was asked.
module TwilioRequests
  # Headers that make twilio-ruby read a stubbed body as JSON rather than as text.
  JSON_HEADERS = { 'Content-Type' => 'application/json' }

  # @param request [WebMock::RequestSignature] request Twilio would have received.
  # @return [Hash] fields its form-encoded body carries.
  def asked_of(request) = URI.decode_www_form(request.body).to_h

  # @param request [WebMock::RequestSignature] request Twilio would have received.
  # @param field [String] name repeated once per value.
  # @return [Array<String>] every value the body carries under that name.
  def all_asked_of(request, field)
    URI.decode_www_form(request.body).filter_map { |name, value| value if name == field }
  end
end

class Minitest::Test
  include TwilioRequests
end
