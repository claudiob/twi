# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a phone number associated to the default messaging service.
  class Phone < Resource
    # Create an incoming phone number within the given area code, attaches the given
    # friendly name and associates with the default messaging service.
    def self.create(area_code:, friendly_name:)
      new(area_code: area_code, friendly_name: friendly_name).create
    end

    def create
      @phone = client.incoming_phone_numbers.create area_code: @params[:area_code],
        emergency_address_sid: Twi.lio.emergency_address_sid, friendly_name: @params[:friendly_name]
      twilio_messaging_service.phone_numbers.create phone_number_sid: @phone.sid
    end

    def id = @phone.sid

    def number = remove_prefix_from @phone.phone_number

  private

    def client
      Twilio::REST::Client.new Twi.lio.account_sid, Twi.lio.auth_token
    end

    def twilio_messaging_service
      client.messaging.v1.services Twi.lio.messaging_sid.to_s
    end
  end
end
