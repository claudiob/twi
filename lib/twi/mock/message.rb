module Twi
  class Mock::Message < Message
    # @return [String] unique identifier
    def id = @params[:id]

    def create
      @id = "SM#{rand}"
      @status = 'delivered'
      # todo rescue and then set @code
    end
  end
end
