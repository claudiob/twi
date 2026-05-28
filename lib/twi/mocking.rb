module Twi
  module Mocking
    def mock
      @mock ||= Twi::Mock.new
    end

    def create_phone(area_code:, friendly_name:)
      phone = (@mock ? Mock::Phone : Phone).new area_code: area_code, friendly_name: friendly_name
      phone.tap &:create
    end
  end

  extend Mocking
end