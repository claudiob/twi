require 'test_helper'

class PhoneTest < Minitest::Test
  # Where Twilio buys a number for the account the phone is created under.
  NUMBERS_URL = %r{api\.twilio\.com/2010-04-01/Accounts/.*/IncomingPhoneNumbers\.json}

  # Where a number already bought joins the default messaging service.
  SERVICE_URL = %r{messaging\.twilio\.com/v1/Services/.*/PhoneNumbers}

  def test_a_number_bought_in_an_area_code_joins_the_default_messaging_service
    stub_request(:post, NUMBERS_URL).to_return headers: JSON_HEADERS,
      body: { sid: 'PN1', phone_number: '+18009007000' }.to_json
    stub_request(:post, SERVICE_URL).to_return body: '{}', headers: JSON_HEADERS

    phone = Twi::Phone.new(area_code: '800', friendly_name: 'Sue').tap &:create

    assert_equal 'PN1', phone.id
    assert_equal '8009007000', phone.number
    assert_requested(:post, NUMBERS_URL) { |request| asked_of(request) == expected_number }
    assert_requested(:post, SERVICE_URL) { |request| asked_of(request) == expected_join }
  end

private

  def expected_number
    { 'AreaCode' => '800', 'EmergencyAddressSid' => ENV['TWILIO_EMERGENCY_SID'],
      'FriendlyName' => 'Sue', }
  end

  def expected_join = { 'PhoneNumberSid' => 'PN1' }
end
