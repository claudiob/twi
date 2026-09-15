module Twi
  class Mock::Phone < Phone
    # Answers whatever the suite arranged, an error before anything else and once only, as the
    # message and the call mocks do: an error left behind would refuse every later number.
    def create
      if error = Twi.mock.phone_error
        Twi.mock.phone_error = nil
        raise Error, error
      elsif Twi.mock.phone
        @id = Twi.mock.phone[:id]
        @number = Twi.mock.phone[:number]
      end
    end
  end
end
