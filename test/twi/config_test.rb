require 'test_helper'

class ConfigTest < Minitest::Test
  def test_the_settings_a_block_is_handed_are_the_ones_the_environment_named
    configured = nil

    Twi.configure { |twilio| configured = twilio }

    assert_same Twi.lio, configured
    assert_equal ENV['TWILIO_SID'], configured.api_key
    assert_equal ENV['TWILIO_CONVERSATION_SERVICE_SID'], configured.conversation_sid
  end
end
