module Twi
  module Mocking
    def mock
      @mock ||= Twi::Mock.new
    end

    def create_phone(...)
      phone(...).tap &:create
    end

    def conversation(...)
      (@mock ? Mock::Conversation : Conversation).new(...)
    end

    def phone(...)
      (@mock ? Mock::Phone : Phone).new(...)
    end
  end

  extend Mocking
end