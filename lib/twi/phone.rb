# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a phone number associated to the default messaging service.
  class Phone < Resource
    # Create a Phone instance within the given area code and friendly name.
    def self.create(area_code:, friendly_name:)
      new(area_code: area_code, friendly_name: friendly_name).create
    end

    # Create an incoming phone number within the area code and friendly name.
    def create
      phone = client.incoming_phone_numbers.create area_code: @params[:area_code],
        emergency_address_sid: Twi.lio.emergency_address_sid, friendly_name: @params[:friendly_name]
      messaging_service.phone_numbers.create phone_number_sid: phone.sid

      @id = phone.sid
      @number = remove_prefix_from phone.phone_number
    end

    # @return [String] unique identifier of the phone.
    attr_reader :id

    # @return [String] 10-digit number.
    attr_reader :number
  end
end
