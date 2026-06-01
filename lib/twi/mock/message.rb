module Twi
  class Mock::Message < Message
    # @return [String] unique identifier
    def id = @params[:id]

    # @return [String] unique identifier
    def sid = @params[:id]

    def create
      if error = Twi.mock.message_error
        Twi.mock.message_error = nil
        raise Error, error
      elsif Twi.mock.message
        @id = Twi.mock.message[:id]
        @status = Twi.mock.message[:status]
      else
        @id = "SM#{rand}"
        @status = 'delivered'
      end
    end
  end
end
