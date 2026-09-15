require 'test_helper'

class DeliveryTest < Minitest::Test
  def test_a_delivery_webhook_names_the_message_its_status_and_the_code_it_failed_with
    params = Twi::Delivery.params_for id: 'SM1', status: 'undelivered', code: '21610'

    delivery = Twi::Delivery.new ActionController::Parameters.new(params.merge From: '+18009007000')

    assert_equal 'SM1', delivery.id
    assert_equal 'undelivered', delivery.status
    assert_equal '21610', delivery.code
    assert_equal '8009007000', delivery.sender
  end

  def test_the_code_a_delivery_failed_with_says_whether_the_reader_unsubscribed
    assert Twi::Delivery.unsubscribed?('21610')
    refute Twi::Delivery.unsubscribed?('30008')

    assert_equal 'https://www.twilio.com/docs/api/errors/30008', Twi::Delivery.url_for('30008')
  end
end
