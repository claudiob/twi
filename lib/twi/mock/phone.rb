module Twi
  class Mock::Phone < Phone
    def create
      if Twi.mock.phone
        @id = Twi.mock.phone[:id]
        @number = Twi.mock.phone[:number]
      elsif Twi.mock.phone_error
        raise Error, Twi.mock.phone_error
      end
    end
  end
end
